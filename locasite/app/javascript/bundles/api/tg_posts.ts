export function getPostsPerDay(startDate: Date | string, endDate: Date | string) {
    const apiUrl = '/api/v1/tg_posts/posts_per_day';
    const params = {
        start_date: startDate.toString(),
        end_date: endDate.toString()
    };

    return fetch(apiUrl + '?' + new URLSearchParams(params))
        .then(response => response.json())
}
