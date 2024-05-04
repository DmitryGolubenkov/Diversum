public static class HttpResponseExtensions
{
    public static HttpResponse SetContent(this HttpResponse response, string content, string contentType)
    {
        response.Content = content;

        response.Headers.Add("Content-Type", contentType);
        response.Headers.Add("Content-Length", content.Length.ToString());

        return response;
    }
}