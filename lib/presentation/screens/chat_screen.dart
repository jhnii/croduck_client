import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/injection/injection.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_bubble_widget.dart';

// 커스텀 Intent 클래스
class SubmitIntent extends Intent {
  const SubmitIntent();
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();

  void _sendMessage(ChatBloc chatBloc) {
    if (_messageController.text.trim().isEmpty) return;

    chatBloc.add(SendMessage(_messageController.text.trim()));
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => getIt<ChatBloc>()..add(const LoadMessages()),
      child: Builder(
        builder: (context) {
          final chatBloc = context.read<ChatBloc>();
          
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  Icon(Icons.smart_toy, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Croduck',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('시스템 설정에서 다크/라이트 모드를 변경할 수 있습니다'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocListener<ChatBloc, ChatState>(
                    listener: (context, state) {
                      // 새로운 메시지가 추가되었을 때 스크롤을 아래로
                      if (state is ChatLoaded) {
                        _scrollToBottom();
                      }
                    },
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        
                        if (state is ChatError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '오류가 발생했습니다',
                                  style: theme.textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(state.message),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    chatBloc.add(const LoadMessages());
                                  },
                                  child: const Text('다시 시도'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (state is ChatLoaded) {
                          if (state.messages.isEmpty) {
                            return const Center(
                              child: Text('메시지가 없습니다. 첫 메시지를 보내보세요!'),
                            );
                          }
                          
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return MessageBubbleWidget(message: message);
                            },
                          );
                        }
                        
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Shortcuts(
                          shortcuts: {
                            LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
                          },
                          child: Actions(
                            actions: {
                              SubmitIntent: CallbackAction<SubmitIntent>(
                                onInvoke: (intent) {
                                  _sendMessage(chatBloc);
                                  return null;
                                },
                              ),
                            },
                            child: TextField(
                              controller: _messageController,
                              focusNode: _textFieldFocusNode,
                              decoration: InputDecoration(
                                hintText: '메시지를 입력하세요... (Shift+Enter로 줄바꿈)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                              ),
                              maxLines: null,
                              minLines: 1,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        onPressed: () => _sendMessage(chatBloc),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        mini: true,
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }
} 