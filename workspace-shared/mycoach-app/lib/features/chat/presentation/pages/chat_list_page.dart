import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: Text(
          AppStrings.messages,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Expand search bar
            },
            icon: const Icon(
              Icons.search,
              size: AppDimensions.iconMd,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Conversations List
          Expanded(
            child: _buildConversationsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show new message bottom sheet
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildConversationsList() {
    // Mock conversations data
    final conversations = [
      _ConversationData(
        name: 'Marie Dupont',
        lastMessage: 'Merci pour la séance d\'aujourd\'hui !',
        lastMessageTime: '14:30',
        isOnline: true,
        hasUnreadMessages: true,
        unreadCount: 2,
        initials: 'MD',
      ),
      _ConversationData(
        name: 'Paul Martin',
        lastMessage: 'À quelle heure demain ?',
        lastMessageTime: 'hier',
        isOnline: false,
        hasUnreadMessages: false,
        unreadCount: 0,
        initials: 'PM',
      ),
      _ConversationData(
        name: 'Julie Leclerc',
        lastMessage: 'Programme reçu, merci !',
        lastMessageTime: 'il y a 2j',
        isOnline: true,
        hasUnreadMessages: true,
        unreadCount: 1,
        initials: 'JL',
      ),
    ];

    if (conversations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _ConversationTile(
          conversation: conversation,
          onTap: () {
            // TODO: Navigate to chat conversation
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: AppDimensions.iconXxl,
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            Text(
              AppStrings.noConversations,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            FilledButton.icon(
              onPressed: () {
                // TODO: Show new message dialog
              },
              icon: const Icon(Icons.edit),
              label: const Text(AppStrings.newMessage),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final _ConversationData conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base,
            vertical: AppDimensions.md,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      conversation.initials,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (conversation.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundLight,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          conversation.lastMessageTime,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: conversation.hasUnreadMessages 
                                ? AppColors.primary 
                                : AppColors.textDisabled,
                            fontWeight: conversation.hasUnreadMessages 
                                ? FontWeight.w600 
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: conversation.hasUnreadMessages 
                                  ? AppColors.textPrimary 
                                  : AppColors.textSecondary,
                              fontWeight: conversation.hasUnreadMessages 
                                  ? FontWeight.w500 
                                  : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.hasUnreadMessages && conversation.unreadCount > 0)
                          Container(
                            constraints: const BoxConstraints(
                              minWidth: AppDimensions.iconBase,
                            ),
                            height: AppDimensions.iconBase,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.xs,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                conversation.unreadCount.toString(),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationData {
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final bool isOnline;
  final bool hasUnreadMessages;
  final int unreadCount;
  final String initials;

  _ConversationData({
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isOnline,
    required this.hasUnreadMessages,
    required this.unreadCount,
    required this.initials,
  });
}