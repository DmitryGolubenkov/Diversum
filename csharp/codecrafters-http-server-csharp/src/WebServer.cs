using System.Net;
using System.Net.Sockets;
using System.Text;

namespace Codecrafters.HttpServerCSharp;

public class WebServer
{
    private DirectoryInfo? Directory { get; init; }
    
    public WebServer(DirectoryInfo? directory)
    {
        Directory = directory;
    }

    public async Task RunAsync()
    {
        var server = new TcpListener(IPAddress.Any, 4221);
        server.Start();

        var pendingRequests = new List<Task>();

        while (true)
        {
            var socket = await server.AcceptSocketAsync();

            if (pendingRequests.Count >= 256)
            {
                var completedTask = Task.WhenAny(pendingRequests);
                pendingRequests.Remove(completedTask);
            }

            var task = Task.Run(() => Serve(socket));
            pendingRequests.Add(task);
        }
    }

    async Task Serve(Socket socket)
    {
        var buffer = new byte[10240];
        var bytesReceived = await socket.ReceiveAsync(buffer);
        
        var httpRequest = ParseRequest(buffer, bytesReceived);
        
        // For extending the app we should use a dictionary with route handler classes, I think
        // But this is out of scope
        if (httpRequest.Path == "/")
            await Send(socket, new HttpResponse()
            {
                HttpCode = "200",
                HttpDetailMessage = "OK"
            });
        else if (httpRequest.Path.StartsWith("/echo/"))
        {
            var data = httpRequest.Path.Split('/', StringSplitOptions.RemoveEmptyEntries)[1];

            await Send(socket, new HttpResponse(data)
            {
                HttpCode = "200",
                HttpDetailMessage = "OK",
            });
        }
        else if (httpRequest.Path == "/user-agent")
        {
            var data = httpRequest.Headers["User-Agent"];
            await Send(socket, new HttpResponse(data)
            {
                HttpCode = "200",
                HttpDetailMessage = "OK",
            });
        }
        else if (httpRequest.Path.StartsWith("/files") && Directory is not null)
        {
            var fileName = httpRequest.Path.Split('/', StringSplitOptions.RemoveEmptyEntries)[1];
            if (httpRequest.HttpMethod == "GET")
            {
                var file = Directory
                    .GetFiles()
                    .FirstOrDefault(x => Path.GetFileNameWithoutExtension(x.FullName) == fileName);

                if (file is null)
                {
                    Console.WriteLine("Could not find file");
                    await Send404(socket);
                }
                else
                {
                    Console.WriteLine("Found file, returning contents");
                    var fileContents = await File.ReadAllTextAsync(file.FullName);


                    var response = HttpResponse.Ok()
                        .SetContent(fileContents, "application/octet-stream");


                    await Send(socket, response);
                }
            }
            else if (httpRequest.HttpMethod == "POST")
            {
                Console.WriteLine("POST /files/");
                var savingPath = Path.Combine(Directory.FullName, fileName);
                Console.WriteLine($"Saving {httpRequest.Content} to {savingPath}");
                await File.WriteAllTextAsync(savingPath, httpRequest.Content);

                var response = new HttpResponse()
                {
                    HttpCode = "201",
                    HttpDetailMessage = "OK",
                };

                await Send(socket, response);
            }
            else await Send404(socket);
        }

        else
        {
            Console.WriteLine("No match");
            await Send404(socket);
        }

        socket.Shutdown(SocketShutdown.Both);
        socket.Close();
    }

    private async Task Send200(Socket socket, string? content = null, string? contentType = null)
    {
        var responseMessage = new HttpResponse()
        {
            HttpCode = "200",
            HttpDetailMessage = "OK",
        };

        if (content is not null)
            responseMessage.SetContent(content, contentType ?? "text/plain");

        await Send(socket, responseMessage);
    }

    private async Task Send404(Socket socket)
    {
        await Send(socket, new HttpResponse()
        {
            HttpCode = "404",
            HttpDetailMessage = "Not Found",
            Headers =
            {
                { "Content-Length", "0" }
            }
        });
    }

    private async Task Send(Socket socket, HttpResponse response)
    {
        var stringResponse = response.ToString();
        Console.WriteLine($"Response: {stringResponse}");
        await socket.SendAsync(Encoding.UTF8.GetBytes(stringResponse), SocketFlags.None);
    }

    HttpRequest ParseRequest(byte[] bytes, int bytesReceived)
    {
        var request = Encoding.UTF8.GetString(bytes.AsSpan(0, bytesReceived));

        Console.WriteLine($"Request {request}");
        var lines = request.Split("\r\n");

        var headParts = lines[0].Split(' ');
        var httpRequest = new HttpRequest()
        {
            HttpMethod = headParts[0],
            Path = headParts[1],
            HttpVersion = headParts[2],
            Headers = new Dictionary<string, string>()
        };

        // headers are like "key: value"
        bool restIsBody = false;
        for (var i = 1; i < lines.Length; i++)
        {
            if (!restIsBody && lines[i] != string.Empty)
            {
                var header = lines[i].Split(':');

                httpRequest.Headers.Add(header[0], header[1].Trim());
            }
            else
            {
                // that is body
                restIsBody = true;

                var contentLines = lines.Skip(i + 1).ToArray();
                var content = string.Join("\r\n", contentLines);

                httpRequest.Content = content;
                Console.WriteLine($"Got content: {content}");
                break;
            }
        }


        return httpRequest;
    }
}