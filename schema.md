# **Mercury Database Schema**

## Users

- Users can own multiple places, groups, catalog items (1-m)
- Multiple users can be friends with multiple other users (m-m)
- Multiple users can follow multiple other users (m-m)
- Multiple users can send friend requests to multiple other users (m-m)
- Users can have multiple feed posts, replies, comments etc (1-m)

## Groups

- Multiple groups can have multiple users (m-m)
- Groups can have multiple places (1-m)
- Groups can have multiple wall posts (1-m)

## Feed Posts

- Feed posts can have multiple replies (1-m)

## **Catalog**

### Categories

- Categories can have multiple items (1-m)

### Items

- Items can have multiple comments (1-m)
