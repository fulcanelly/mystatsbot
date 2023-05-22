SELECT
    chats.id as chat_id,
    chats.first_name,
    chats.username,
    chats.is_deleted,
    days.date,
    COUNT(tg_posts.id) AS post_count
FROM chats
INNER JOIN tg_posts ON tg_posts.chat_id = chats.id
INNER JOIN days ON days.id = tg_posts.day_id
GROUP BY chats.id, days.date
ORDER BY post_count DESC;
