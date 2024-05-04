using System.Text;

public class HttpResponse
{
    public HttpResponse()
    {
    }

    public HttpResponse(string content, string contentType = "text/plain") => this.SetContent(content, contentType);

    private string HttpVersion { get; set; } = "HTTP/1.1";

    public required string HttpCode { get; set; }

    public Dictionary<string, string> Headers { get; set; } = new Dictionary<string, string>();

    public string? HttpDetailMessage { get; set; }

    internal string? Content { get; set; }

    public override string ToString()
    {
        var stringBuilder = new StringBuilder();

        stringBuilder.Append($"{HttpVersion} {HttpCode} {HttpDetailMessage}\r\n");

        foreach (var header in Headers)
            stringBuilder.Append($"{header.Key}: {header.Value}\r\n");

        // Ensure Content-Length is always added
        if (!Headers.ContainsKey("Content-Length"))
        {
            stringBuilder.Append("Content-Length: ");
            stringBuilder.Append(Content?.Length.ToString() ?? "0");
            stringBuilder.Append("\r\n");
        }

        if (Content is not null)
        {
            stringBuilder.Append("\r\n"); // line between headers and content
            stringBuilder.Append(Content);
        }


        stringBuilder.Append("\r\n");
        return stringBuilder.ToString();
    }

    public static HttpResponse Ok()
    {
        return new HttpResponse()
        {
            HttpCode = "200",
            HttpDetailMessage = "OK"
        };
    }
}