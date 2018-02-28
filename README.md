# Handling Messaging Intents

MessagingIntents is an implementation of a simple messaging app integrated with Siri, allowing users to send and search for MessagingIntents messages using Siri.

## Overview

This sample implements three intent handlers: [`INSendMessageIntentHandling`](https://developer.apple.com/documentation/sirikit/insendmessageintenthandling), [`INSearchForMessagesIntentHandling`](https://developer.apple.com/documentation/sirikit/insearchformessagesintenthandling) and [`INSetMessageAttributeIntentHandling`](https://developer.apple.com/documentation/sirikit/insetmessageattributeintenthandling).

The project is organized into three targets:

1. `MessagingIntents`: an iOS app containing a table view controller displaying a history of the messages sent and
received using Siri.
2. `SiriMessagingExtension`: an implementation of Siri intent handlers, used to enable interaction between Siri
and the app.
3. `MessagingIntentsFramework`: a collection of models and search logic a real-world messaging application might 
have. This framework is imported both in the app and in the extension.

- Note: Test contacts used to send and search messages are pulled from `Contacts.plist`.

## Setup

1. Enable Siri in the simulator.
2. Enable the extension for SiriKit in Siri Settings.
3. Launch the extension in the simulator and try the sample utterances.

## 1. Sending Messages

This handler allows users to send MessagingIntent messages using Siri. This functionality is enabled by conforming to `INSendMessageIntentHandling` ([View in Source](x-source-tag://SendMessageHandler)).

### Test Queries

**"Send a message to John  using MessagingIntents"**

Since Ochoa  is not in one of our contacts, Siri tries to find close matches and asks if we want to send the message to John Doe.

**"Send a message to Jane using MessagingIntents"**

Success if the [`INSendMessageIntent`](https://developer.apple.com/documentation/sirikit/insendmessageintent) can be *confidently* resolved to a single user.
Otherwise, it may be necessary to ask Siri to confirm the recipient. In out contacts list there is no "**Jane**", but we do have a "**Jane** Doe".
We need Siri to ask the user to confirm if they want this alternate recipient.

``` swift
/*
 Check if the ranked user is a confident match, meaning we're reasonably certain this is the person the user
 was referring to, otherwise ask Siri to help confirm the `recipient`.
 */
let result: INPersonResolutionResult
if firstRankedUser.isConfidentMatch {
    result = .success(with: recipient)
} else {
    result = .confirmationRequired(with: recipient)
}
```

## 2. Searching for Messages
This handler allows users to search for MessagingIntent messages sent to us using Siri. This functionality is enabled by conforming to `INSearchForMessagesIntentHandling` ([View in Source](x-source-tag://SearchForMessagesHandler)).

### Test Queries

**"Read my messages from John Doe using MessagingIntents"**

When loading the app for the first time, three messages from user "John Doe" get loaded.
Siri reads out these three messages one by one. Each message get marked as *read* using the `SetMessageAttributeHandler` and will not be read by Siri the next time the user performs the query.

**"Read my message from Ochoa using MessagingIntents"**

The query fails – we did not receive any messages from Ochoa.

## 3. Modifying Message Attributes

This handler updates the state of a MessagingIntent. This functionality is enabled by conforming to `INSetMessageAttributeIntentHandling` ([View in Source](x-source-tag://SetMessageAttributeHandler)).

### Test Queries

**"Read my messages from John Doe using MessagingIntents"**

The message is marked as read.

## Miscellaneous

`MessagingIntentsFramework` implements a fake messaging web service, containing two useful classes: `MessagesProvider` and `UserDatabase`.
