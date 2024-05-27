using Microsoft.Playwright;

using var playwright = await Playwright.CreateAsync();
//above this line throws exception "Either use the source generator APIs..."
var b = playwright.Firefox;
if (args.Any() && args?[0] == "install")
{
    Environment.Exit(Microsoft.Playwright.Program.Main(new[] { "install" , b.Name }));
}
bool inDocker = Environment.GetEnvironmentVariable("DOTNET_RUNNING_IN_CONTAINER") == "true";
Console.WriteLine(!inDocker ? "Starting program..." : "Starting program in headless mode...");
await using var browser = await b.LaunchAsync(new BrowserTypeLaunchOptions { Headless = inDocker });

var context = await browser.NewContextAsync();
var page = await context.NewPageAsync();

await page.GotoAsync("https://www.bing.com");