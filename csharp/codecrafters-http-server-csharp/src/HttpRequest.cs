public class HttpRequest
{
    public required string HttpMethod { get; set; }

    public required string Path { get; set; }

    public required string HttpVersion { get; set; }

    public string? Content { get; set; }
    
    public required Dictionary<string, string> Headers { get; set; }
}