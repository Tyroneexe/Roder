// conversations (collection)
// └─ conversationId1 (document)
//    ├─ participants: [userId1, userId2]
//    ├─ lastMessage: "Hello, how are you?"
//    ├─ timestamp: 1626501935
//    └─ messages (subcollection)
//       └─ messageId1 (document)
//          ├─ senderId: userId1
//          ├─ content: "Hey, I'm good. How about you?"
//          ├─ timestamp: 1626501978
//          └─ ...
//       └─ messageId2 (document)
//          ├─ senderId: userId2
//          ├─ content: "I'm doing great too!"
//          ├─ timestamp: 1626502032
//          └─ ...
//       └─ messageId3 (document)
//          ├─ senderId: userId1
//          ├─ content: "That's awesome!"
//          ├─ timestamp: 1626502081
//          └─ ...