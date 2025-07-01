# 🏛️ Hexagonal Architecture Rules - Croduck Client

> **헥사고날 아키텍처 (Ports and Adapters Pattern) 구현 가이드라인**

---

## 📜 Core Principles

이 프로젝트는 **헥사고날 아키텍처**를 기반으로 구성되며, 다음 핵심 원칙을 준수합니다:

1. **🎯 도메인 중심성**: 비즈니스 로직이 외부 의존성으로부터 완전히 격리
2. **🔄 의존성 역전**: 모든 의존성이 도메인 레이어를 향함
3. **🔌 포트와 어댑터**: 인터페이스를 통한 느슨한 결합
4. **🏗️ 레이어 분리**: 각 레이어의 명확한 책임과 경계

---

## 🏗️ Layer Structure Rules

| Layer | Purpose | Dependencies | Rules |
|-------|---------|--------------|-------|
| **Domain** | 순수 비즈니스 로직 (What) | 없음 (외부 독립) | ❌ Flutter, DB, API 금지<br>✅ 엔티티, 포트(Repository Interface)만 |
| **Application** | 앱 기능 실행 (How) | Domain만 의존 | ✅ 유스케이스, 애플리케이션 서비스 |
| **Presentation** | UI 어댑터 (Incoming) | Application, Domain 의존 | ✅ BLoC, Widget, Theme<br>❌ Infrastructure 직접 접근 금지 |
| **Infrastructure** | 외부 시스템 구현 (Outgoing)| Domain만 의존 | ✅ Repository 구현체<br>✅ DataSource, Model, 외부 API 연동 |
| **Core** | 공통 인프라 | 모든 레이어에서 사용 | ✅ DI, 상수, 유틸리티 |

---

## 📁 Directory Structure Convention

```
lib/
├── core/                           # 🔧 공통 인프라스트럭처
│   ├── injection/                  # 의존성 주입 설정
│   │   ├── injection.dart
│   │   └── injection.config.dart
│   ├── constants/                  # 앱 전역 상수
│   ├── utils/                      # 유틸리티 함수
│   └── extensions/                 # 확장 함수
│
├── domain/                         # 👑 비즈니스 레이어 (What)
│   ├── entities/                   # 비즈니스 엔티티
│   │   └── message_entity.dart
│   ├── repositories/               # 포트 (인터페이스)
│   │   └── chat_repository.dart
│   └── failures/                   # 도메인 실패
│       └── failure.dart
│
├── application/                    # 💼 애플리케이션 레이어 (How)
│   └── usecases/                   # 비즈니스 로직 실행
│       ├── get_messages_usecase.dart
│       └── send_message_usecase.dart
│
├── infrastructure/                 # 🔌 외부 시스템 어댑터 (Outgoing)
│   ├── persistence/                # 로컬 DB, 파일 등 영속성 데이터 처리
│   │   └── chat_local_datasource.dart
│   ├── remote/                     # 외부 API 등 원격 데이터 처리
│   │   └── chat_remote_datasource.dart
│   ├── models/                     # 데이터 변환 모델 (DTOs)
│   └── repositories/               # Repository 구현체
│
└── presentation/                   # 🎨 UI 어댑터 (Incoming)
    ├── bloc/                       # 상태 관리
    │   ├── chat_bloc.dart
    │   ├── chat_event.dart
    │   └── chat_state.dart
    ├── screens/                    # 화면 위젯
    │   └── chat_screen.dart
    ├── widgets/                    # 재사용 위젯
    │   └── message_bubble_widget.dart
    └── theme/                      # UI 테마
        └── app_theme.dart
```

---

## 🎯 Naming Conventions

### Domain Layer

```dart
// ✅ Entities: 명사 + Entity
class MessageEntity { }
class UserEntity { }

// ✅ Use Cases: 동사 + UseCase (Application Layer)
class SendMessageUseCase { }
class GetMessagesUseCase { }

// ✅ Repositories: 명사 + Repository (Domain Layer, Interface)
abstract class ChatRepository { }
abstract class UserRepository { }

// ✅ Failures: 도메인 실패 + Failure
class ValidationFailure extends Failure { }
class BusinessRuleFailure extends Failure { }
```

### Data Layer

```dart
// ✅ Models: 명사 + Model
class MessageModel extends MessageEntity { }

// ✅ Repository 구현체: 인터페이스 + Impl
class ChatRepositoryImpl implements ChatRepository { }

// ✅ DataSources: 명사 + DataSource
abstract class ChatRemoteDataSource { }
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource { }
```

### Presentation Layer

```dart
// ✅ BLoCs: 기능 + Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> { }

// ✅ Events: 동사 + 명사
class SendMessage extends ChatEvent { }
class LoadMessages extends ChatEvent { }

// ✅ States: 상태 설명
class ChatLoading extends ChatState { }
class ChatLoaded extends ChatState { }
```

---

## 📋 Dependency Rules

### ✅ 허용되는 의존성 방향

```
Presentation → Application → Domain
     ↓              ↓           ↓
   Core           Core         Core
                    ↑           ↑
          Infrastructure   → Domain
```

### ❌ 금지되는 의존성

- **Domain → 다른 레이어** (완전 격리 필수)
- **Presentation → Infrastructure** (직접 접근 금지)
- **Infrastructure → Presentation** (역방향 의존성 금지)

---

## 🔧 Implementation Rules

### 1. 의존성 주입 규칙

```dart
// ✅ 모든 구현체는 @Injectable 어노테이션
@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository { }

// ✅ Use Cases는 @injectable
@injectable
class SendMessageUseCase { }

// ✅ BLoCs도 @injectable
@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> { }
```

### 2. 에러 처리 규칙

```dart
// ✅ Either 타입 사용 (함수형 에러 처리)
Future<Either<Failure, MessageEntity>> sendMessage(String content);

// ✅ fold를 사용한 에러 처리
result.fold(
  (failure) => emit(ChatError(failure.toString())),
  (success) => emit(ChatLoaded(success)),
);
```

### 3. 데이터 변환 규칙

```dart
// ✅ Model ↔ Entity 변환 메서드 필수
class MessageModel extends MessageEntity {
  factory MessageModel.fromEntity(MessageEntity entity) { }
  MessageEntity toEntity() { }
  
  // ✅ JSON 직렬화 지원
  factory MessageModel.fromJson(Map<String, dynamic> json) { }
  Map<String, dynamic> toJson() { }
}
```

---

## 🧪 Testing Rules

### Domain Layer 테스트
- ✅ 순수 단위 테스트만
- ✅ Mock 없이 테스트 가능해야 함
- ❌ 외부 의존성 없어야 함

### Data Layer 테스트
- ✅ Repository 구현체 테스트
- ✅ DataSource Mock 사용
- ✅ 데이터 변환 테스트

### Presentation Layer 테스트
- ✅ BLoC 테스트 (mocktail 사용)
- ✅ Widget 테스트
- ✅ Use Case Mock 사용

---

## 🚀 Development Workflow

### 1. 새 기능 추가 순서

1. **Domain** 먼저: Entity → Repository Interface → UseCase
2. **Data** 다음: Model → DataSource → Repository 구현
3. **Presentation** 마지막: BLoC → Screen → Widget

### 2. 코드 생성 명령어

```bash
# 의존성 주입 & JSON 코드 생성
flutter packages pub run build_runner build --delete-conflicting-outputs

# 의존성 설치
flutter pub get
```

### 3. 검증 명령어

```bash
# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 빌드 확인
flutter build apk --debug
```

---

## 🎯 Architecture Validation Checklist

### ✅ Domain Layer 검증

- [ ] 외부 패키지 import 없음 (equatable, dartz 제외)
- [ ] Flutter 위젯 사용 없음
- [ ] 비즈니스 로직만 포함
- [ ] 인터페이스만 정의 (구현체 없음)

### ✅ Data Layer 검증

- [ ] Domain 인터페이스 구현
- [ ] 외부 라이브러리와 연결
- [ ] Entity ↔ Model 변환 구현
- [ ] 에러를 Failure로 변환

### ✅ Presentation Layer 검증

- [ ] Domain Use Cases만 사용
- [ ] BLoC 패턴 적용
- [ ] UI 로직과 비즈니스 로직 분리
- [ ] Data 레이어 직접 접근 없음

### ✅ Core Layer 검증

- [ ] 모든 레이어에서 안전하게 사용 가능
- [ ] 비즈니스 로직 없음
- [ ] 유틸리티와 설정만 포함

---

## 🔍 Code Review Guidelines

### Domain Layer Review

```dart
// ❌ 잘못된 예시 - Flutter 의존성
import 'package:flutter/material.dart'; // 금지!

// ✅ 올바른 예시 - 순수 도메인
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
```

### Data Layer Review

```dart
// ❌ 잘못된 예시 - Presentation 접근
import '../../presentation/bloc/chat_bloc.dart'; // 금지!

// ✅ 올바른 예시 - Domain만 의존
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
```

### Presentation Layer Review

```dart
// ❌ 잘못된 예시 - Data 직접 접근
import '../../data/repositories/chat_persistence.dart'; // 금지!

// ✅ 올바른 예시 - Domain UseCase 사용
import '../../domain/usecases/send_message_usecase.dart';
```

---

## 📚 Best Practices

### 1. 에러 처리

```dart
// ✅ Domain에서 비즈니스 에러 정의
class ValidationFailure extends Failure {
  final String field;
  const ValidationFailure(this.field);
}

// ✅ Data에서 기술적 에러를 도메인 에러로 변환
try {
  final result = await api.sendMessage(content);
  return Right(result);
} catch (e) {
  return Left(ServerFailure(e.toString()));
}
```

### 2. 상태 관리

```dart
// ✅ BLoC에서 UseCase 호출
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  
  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final result = await sendMessageUseCase(event.content);
    result.fold(
      (failure) => emit(ChatError(failure.toString())),
      (message) => emit(ChatLoaded([...currentMessages, message])),
    );
  }
}
```

### 3. 의존성 주입

```dart
// ✅ 인터페이스로 등록
@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository { }

// ✅ GetIt에서 가져와서 사용
final chatBloc = getIt<ChatBloc>();
```

---

## 🎉 Benefits of This Architecture

1. **🧪 테스트 용이성**: 각 레이어가 독립적으로 테스트 가능
2. **🔧 유지보수성**: 변경사항이 다른 레이어에 영향을 주지 않음
3. **📈 확장성**: 새로운 어댑터 추가가 쉬움
4. **🛡️ 비즈니스 로직 보호**: 도메인 레이어가 외부 의존성으로부터 격리
5. **🔄 기술 변경 용이성**: 데이터베이스나 API 변경 시 어댑터만 수정

---

## 📞 Support

이 아키텍처에 대한 질문이나 개선사항이 있다면 팀 리드에게 문의하세요.

**Created**: `$(date +'%Y-%m-%d')`  
**Version**: `1.0.0`  
**Author**: Croduck Development Team 