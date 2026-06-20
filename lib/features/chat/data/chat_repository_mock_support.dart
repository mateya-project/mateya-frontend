part of 'chat_repository.dart';

final ChatParticipant _me = ChatParticipant(id: 'me', name: '나');

final DateTime _now = DateTime.now();

final ChatParticipant _jiwon = ChatParticipant(
  id: 'jiwon',
  name: 'Ji-Won',
  secondaryName: '김지원',
  avatarUrl:
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=240&q=80',
);

final ChatParticipant _nicolas = ChatParticipant(
  id: 'nicolas',
  name: 'Nicolas',
  secondaryName: '니콜라스',
  avatarUrl:
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=240&q=80',
);

final ChatParticipant _soyeon = ChatParticipant(
  id: 'soyeon',
  name: '서연',
  avatarUrl:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80',
);

final ChatParticipant _minho = ChatParticipant(
  id: 'minho',
  name: '민호',
  avatarUrl:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
);

final List<ChatRoom> _mockRooms = <ChatRoom>[
  ChatRoom(
    id: 'gyeongbokgung-walk',
    type: ChatRoomType.group,
    title: '경복궁 산책 모임',
    imageUrl:
        'https://images.unsplash.com/photo-1565967511849-76a60a516170?auto=format&fit=crop&w=240&q=80',
    participantCount: 18,
    lastMessageAt: _now.subtract(const Duration(minutes: 15)),
    unreadCount: 1,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'g-1',
        sender: _me,
        sentAt: _now.subtract(const Duration(minutes: 38)),
        isMine: true,
        bubbles: const <ChatBubble>[
          ChatBubble(originalText: '다들 뭐하고 지내요!'),
          ChatBubble(originalText: '우리 내일 보는건가요?'),
        ],
      ),
      ChatMessageGroup(
        id: 'g-2',
        sender: _jiwon,
        sentAt: _now.subtract(const Duration(minutes: 20)),
        isTranslatedVisible: true,
        bubbles: const <ChatBubble>[
          ChatBubble(
            originalText: '가나다라마바사',
            translatedText: 'See you all at the palace gate.',
          ),
          ChatBubble(
            originalText: '가나다라마바사',
            translatedText: 'I will arrive around 1:40 PM.',
          ),
          ChatBubble(
            originalText: '가나다라마바사가나다라마바사 가나다라마바사\n가나다라마바사?',
            translatedText:
                'Should we meet in front of the ticket booth\nbefore we start walking?',
          ),
        ],
      ),
      ChatMessageGroup(
        id: 'g-3',
        sender: _nicolas,
        sentAt: _now.subtract(const Duration(minutes: 15)),
        isTranslatedVisible: true,
        bubbles: const <ChatBubble>[
          ChatBubble(
            originalText: 'ASDFASdfsadf',
            translatedText: '좋아요, 저도 그쪽으로 갈게요.',
          ),
          ChatBubble(
            originalText: 'asdf1234asDFA',
            translatedText: '혹시 늦으면 채팅으로 남길게요.',
          ),
          ChatBubble(
            originalText: 'asdfasdf!@#\$!@#ADSFSADfasd\nasdfasdfasdf!@#\$@#',
            translatedText: '경복궁역 4번 출구 쪽에서 먼저 기다리고 있을게요.',
          ),
        ],
      ),
    ],
  ),
  ChatRoom(
    id: 'hongdae-language',
    type: ChatRoomType.direct,
    title: 'Nicolas 니콜라스',
    imageUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
    participantCount: 2,
    lastMessageAt: _now.subtract(const Duration(hours: 2, minutes: 10)),
    unreadCount: 3,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'd-1',
        sender: _nicolas,
        sentAt: _now.subtract(const Duration(hours: 2, minutes: 10)),
        isTranslatedVisible: true,
        bubbles: const <ChatBubble>[
          ChatBubble(
            originalText: 'Can we switch to Korean after 8 PM?',
            translatedText: '오늘 8시 이후에는 한국어로 바꿔도 될까요?',
          ),
        ],
      ),
    ],
  ),
  ChatRoom(
    id: 'itaewon-dinner',
    type: ChatRoomType.direct,
    title: '서연',
    imageUrl:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=240&q=80',
    participantCount: 2,
    lastMessageAt: _now.subtract(const Duration(days: 1, hours: 3)),
    unreadCount: 0,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'd-2',
        sender: _soyeon,
        sentAt: _now.subtract(const Duration(days: 1, hours: 3)),
        bubbles: const <ChatBubble>[ChatBubble(originalText: '여기서 만나요!')],
      ),
    ],
  ),
  ChatRoom(
    id: 'han-river-group',
    type: ChatRoomType.group,
    title: '한강 밤 산책 번개',
    imageUrl:
        'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=240&q=80',
    participantCount: 9,
    lastMessageAt: _now.subtract(const Duration(days: 10)),
    unreadCount: 12,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'g-4',
        sender: _minho,
        sentAt: _now.subtract(const Duration(days: 10)),
        bubbles: const <ChatBubble>[
          ChatBubble(originalText: '오늘 코스는 잠수교부터 시작해요.'),
        ],
      ),
    ],
  ),
  ChatRoom(
    id: 'pottery-class',
    type: ChatRoomType.group,
    title: '이천 도자기 체험 클래스',
    imageUrl:
        'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&w=240&q=80',
    participantCount: 14,
    lastMessageAt: _now.subtract(const Duration(days: 380)),
    unreadCount: 20,
    messageGroups: <ChatMessageGroup>[
      ChatMessageGroup(
        id: 'g-5',
        sender: _soyeon,
        sentAt: _now.subtract(const Duration(days: 380)),
        bubbles: const <ChatBubble>[
          ChatBubble(originalText: '준비물은 앞치마만 챙겨주세요.'),
        ],
      ),
    ],
  ),
];

ChatRoom _cloneRoom(ChatRoom room) {
  return room.copyWith(
    messageGroups: room.messageGroups.map(_cloneGroup).toList(),
  );
}

ChatMessageGroup _cloneGroup(ChatMessageGroup group) {
  return group.copyWith(
    sender: group.sender.copyWith(),
    bubbles: group.bubbles
        .map(
          (bubble) => bubble.copyWith(
            attachments: bubble.attachments
                .map((attachment) => attachment.copyWith())
                .toList(),
          ),
        )
        .toList(),
  );
}
