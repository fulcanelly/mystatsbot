export async function getPostsPerDay({chatId, startDate, endDate}:{ chatId?: string, startDate?: string, endDate?: string }) {
    const apiUrl = '/api/v1/tg_posts/posts_per_day';
    if (chatId) {
        const params = {
            chat_id: chatId,
            start_date: startDate,
            end_date: endDate
        };

        const response = await fetch(apiUrl + '?' + new URLSearchParams(params));
        const json = await response.json()
        return json.map(([day, count]) => [new Date(day), count]) ?? []
    } else {
        const params = {
            start_date: startDate,
            end_date: endDate
        };

        const response = await fetch(apiUrl + '?' + new URLSearchParams(params));
        const json = await response.json()
        return json.map(([day, count]) => [new Date(day), count]) ?? []
    }
}

export async function getChatStatsOfDay(day: Date | string) {
    const apiUrl = '/api/v1/tg_posts/chat_stats_of_day';
    const params = {
        day: day.toString()
    };

    const response = await fetch(apiUrl + '?' + new URLSearchParams(params));
    return await response.json();
}

