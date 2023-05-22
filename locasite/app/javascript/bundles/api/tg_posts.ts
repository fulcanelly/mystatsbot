export async function getPostsPerDay(startDate: Date | string, endDate: Date | string) {
    const apiUrl = '/api/v1/tg_posts/posts_per_day';
    const params = {
        start_date: startDate.toString(),
        end_date: endDate.toString()
    };

    const response = await fetch(apiUrl + '?' + new URLSearchParams(params));
    return await response.json();
}

export async function getChatStatsOfDay(day: Date | string) {
    const apiUrl = '/api/v1/tg_posts/chat_stats_of_day';
    const params = {
        day: day.toString()
    };

    const response = await fetch(apiUrl + '?' + new URLSearchParams(params));
    return await response.json();
}
