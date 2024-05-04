using Codecrafters.HttpServerCSharp;

var cliArgs = ParseArgs();

DirectoryInfo? directory = null;

if (cliArgs.TryGetValue("--directory", out var value))
{
    if (string.IsNullOrWhiteSpace(value) || !Path.Exists(value))
        throw new ArgumentException("Invalid directory path");

    directory = new DirectoryInfo(value);
}

var webServer = new WebServer(directory);

await webServer.RunAsync();





Dictionary<string, string?> ParseArgs()
{
    Console.WriteLine("Parsing args");
    var dictionary = new Dictionary<string, string?>();

    for (int i = 0; i < args.Length; i += 1)
    {
        dictionary.Add(args[i], i + 1 < args.Length ? args[i + 1] : null);
    }

    foreach (var pair in dictionary)
    {
        Console.WriteLine($"{pair.Key}={pair.Value}");
    }

    return dictionary;
}


