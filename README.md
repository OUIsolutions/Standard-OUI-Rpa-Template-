# 🤖 OUI Solutions Standard RPA Template

A beginner-friendly template for creating Robot Process Automation (RPA) bots using VibeScript that can control web browsers automatically.

## 🎯 What is this?

This is a **Robot Process Automation (RPA)** template that teaches you how to build bots that can:
- 🌐 Open web browsers automatically
- 🖱️ Click buttons and fill forms without human interaction
- 📊 Extract data from websites
- 💾 Save information to files

**In this example**, we built a bot that searches Wikipedia articles and saves their content - but you can modify it to automate any web task!

## 📋 What Does This Bot Do?

This Wikipedia bot performs these steps automatically:

1. 🚀 **Opens Chrome browser** (without you clicking anything!)
2. 🔍 **Goes to Wikipedia.org**
3. 🔎 **Types your search term** in the search box
4. 📰 **Clicks on the first result**
5. 📄 **Reads the entire article**
6. 💾 **Saves it as a JSON file** on your computer

## 🎬 Quick Start (For Complete Beginners)

### What You'll Need:
- A computer running Linux
- Internet connection
- Basic command line knowledge (we'll teach you!)

### Step-by-Step Installation

#### 🖥️ Step 1: Open Your Terminal/Command Line

Press `Ctrl + Alt + T` to open the terminal.

#### 📦 Step 2: Install VibeScript (The Programming Language)

VibeScript is a special programming language that controls web browsers. Copy and paste this command:

```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.15.1/vibescript.out -o vibescript.out && sudo chmod +x vibescript.out && sudo mv vibescript.out /bin/vibescript
```

**What this does:**
- `curl -L` → Downloads VibeScript from the internet
- `chmod +x` → Makes it executable (runnable)
- `mv /bin/vibescript` → Installs it system-wide

#### 🌐 Step 3: Download Chrome and ChromeDriver

These are the tools that let our bot control Chrome browser:

```bash
# Create a folder for Chrome
mkdir -p chrome

# Download ChromeDriver (the controller)
curl -L https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.94/linux64/chromedriver-linux64.zip -o chromedriver.zip

# Download Chrome browser
curl -L https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.94/linux64/chrome-linux64.zip -o chrome-linux64.zip

# Extract both files
unzip chromedriver.zip -d chrome && unzip chrome-linux64.zip -d chrome

# Clean up zip files
rm *.zip
```

#### 🤖 Step 4: Download Our Wikipedia Bot

```bash
curl -L https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/cli.lua -o cli.lua
```

This downloads the actual bot code!

#### ⚙️ Step 5: Set Up the Bot

First, create a shortcut name for our bot:
```bash
vibescript add_script --file cli.lua wikisearch
```

Now you can use `wikisearch` instead of typing the full file name!

#### 🔧 Step 6: Tell the Bot Where Chrome Is

```bash
vibescript wikisearch configure --chromedriver_path chrome/chromedriver-linux64/chromedriver --chrome_binary chrome/chrome-linux64/chrome
```

This tells the bot:
- Where to find ChromeDriver (the controller)
- Where to find Chrome browser

#### 🎉 Step 7: Run Your First Search!

```bash
vibescript wikisearch run --article "Albert Einstein" --out_dir my_results
```

**What happens:**
1. Chrome opens automatically
2. Goes to Wikipedia
3. Searches for "Albert Einstein"
4. Saves the article to `my_results/result.json`

## 📚 Detailed Usage Guide

### Understanding the Commands

Our bot has two main commands: `configure` and `run`.

#### 🔧 Configure Command

**Purpose:** Tells the bot where to find Chrome on your computer

**Full syntax:**
```bash
vibescript wikisearch configure --chromedriver_path <path> --chrome_binary <path>
```

**Parameters explained:**

| Parameter | What it means | Example |
|-----------|---------------|---------|
| `--chromedriver_path` | Location of ChromeDriver (the controller) | `chrome/chromedriver-linux64/chromedriver` |
| `--chrome_binary` | Location of Chrome browser | `chrome/chrome-linux64/chrome` |

**Short version (using aliases):**
```bash
vibescript wikisearch configure -d <chromedriver> -c <chrome>
```

#### 🏃 Run Command

**Purpose:** Actually searches Wikipedia and saves results

**Full syntax:**
```bash
vibescript wikisearch run --article <article_name> --out_dir <folder>
```

**Parameters explained:**

| Parameter | What it means | Example |
|-----------|---------------|---------|
| `--article` | What to search on Wikipedia | `"Python programming"` |
| `--out_dir` | Where to save results | `results` |

**Short version:**
```bash
vibescript wikisearch run -a "Python programming" -o results
```

### 📤 Understanding the Output

After running, you'll find:

```
my_results/
├── result.json      # The Wikipedia article
└── downloads/       # Any images or files from the page
```

**The JSON file looks like:**
```json
{
  "hatnote": "This article is about the physicist. For other uses, see Albert Einstein (disambiguation).",
  "text": "Albert Einstein (14 March 1879 – 18 April 1955) was a German-born theoretical physicist..."
}
```

- `hatnote`: Special notes at the top of Wikipedia articles
- `text`: The actual article content

## 🛠️ Downloads and Installation Options

### Pre-built Releases

| File | What it's for | How to use |
|------|---------------|------------|
| [cli.lua](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/cli.lua) | Command-line tool | Use with `vibescript` command |
| [api_lib.lua](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api_lib.lua) | Programming library | Import in Lua scripts with `require()` |
| [api.lua](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api.lua) | Embedded library | Copy-paste into other projects |

## 👨‍💻 For Developers: Using the API

### Basic API Usage

If you want to use this bot in your own Lua programs:

1. **Download the API library:**
```bash
curl -L https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api_lib.lua -o wikisearch.lua
```

2. **Create your own script (`my_wikipedia_bot.lua`):**
```lua
-- Import the Wikipedia bot library
local wikisearch = require("wikisearch")

-- Search for an article
local result = wikisearch.fetch_wikipedia_article({
    article = "Linux",                                              -- What to search
    chromedriver_path = "chrome/chromedriver-linux64/chromedriver", -- ChromeDriver location
    chrome_binary = "chrome/chrome-linux64/chrome",                 -- Chrome location
    outdir = "my_search_results"                                    -- Where to save
})

-- Check if we found something
if result then
    print("=== Wikipedia Article Found ===")
    
    -- Print the hatnote if it exists
    if result.hatnote then
        print("Note: " .. result.hatnote)
    end
    
    -- Print first 500 characters of the article
    print("\nArticle preview:")
    print(string.sub(result.text, 1, 500) .. "...")
else
    print("Article not found!")
end
```

3. **Run your script:**
```bash
vibescript my_wikipedia_bot.lua
```

### Advanced API Example

```lua
local wikisearch = require("wikisearch")

-- List of articles to search
local articles = {"Python programming", "JavaScript", "Lua programming"}

-- Search multiple articles
for _, article in ipairs(articles) do
    print("\nSearching for: " .. article)
    
    local result = wikisearch.fetch_wikipedia_article({
        article = article,
        chromedriver_path = "chrome/chromedriver-linux64/chromedriver",
        chrome_binary = "chrome/chrome-linux64/chrome",
        outdir = "results/" .. article:gsub(" ", "_")
    })
    
    if result then
        print("✓ Found! Saved to results/" .. article:gsub(" ", "_"))
    else
        print("✗ Not found")
    end
end
```

## 🏗️ Building From Source (Advanced)

### Prerequisites

1. **Install Darwin (Build Tool):**
```bash
curl -L https://github.com/OUIsolutions/Darwin/releases/download/0.4.0/darwin.out -o darwin.out && sudo chmod +x darwin.out && sudo mv darwin.out /usr/bin/darwin
```

2. **Clone this repository:**
```bash
git clone https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-.git
cd Standard-OUI-Rpa-Template-
```

3. **Build everything:**
```bash
darwin run_blueprint
```

This creates all files in the `release/` directory.

### Project Structure Explained

```
Standard-OUI-Rpa-Template-/
├── api/                    # Source code for the library
│   ├── main.lua           # Main API functions
│   └── scripts.lua        # JavaScript code for browser
├── cli/                    # Source code for command-line tool
│   └── main.lua           # CLI implementation
├── release/               # Built files (generated)
│   ├── cli.lua           # Complete CLI tool
│   ├── api.lua           # Standalone API
│   └── api_lib.lua       # Importable API
└── README.md             # This file
```

### Understanding the Code Structure

#### `api/main.lua`
Contains the core functionality:
- Browser initialization
- Wikipedia navigation
- Content extraction

#### `api/scripts.lua`
JavaScript code that runs inside the browser to extract text efficiently.

#### `cli/main.lua`
Command-line interface that:
- Parses arguments
- Calls API functions
- Handles errors

## 🚨 Troubleshooting Guide

### Common Problems and Solutions

#### Problem: "Command not found: vibescript"
**Solution:** VibeScript isn't installed properly. Re-run Step 2.

#### Problem: "Chrome failed to start"
**Solution:** You might need to install Chrome dependencies:
```bash
sudo apt-get install -y libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libasound2
```

#### Problem: "Article not found"
**Solutions:**
1. Check spelling
2. Try simpler search terms
3. Check internet connection

#### Problem: "Permission denied"
**Solution:** Add `sudo` before commands that require administrator privileges

### Getting Help

1. Check existing [issues](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/issues)
2. Create a new issue with:
   - Your operating system
   - The command you ran
   - The error message
   - What you expected to happen

## 🎓 Learning Resources

### Beginner Tutorials

1. **Understanding RPA:**
   - RPA = Robot Process Automation
   - Automates repetitive tasks
   - No human interaction needed

2. **How Web Automation Works:**
   - WebDriver controls the browser
   - Sends commands like "click here" or "type this"
   - Can read page content

3. **JSON Basics:**
   ```json
   {
     "key": "value",
     "number": 123,
     "list": ["item1", "item2"]
   }
   ```

### Next Steps

After mastering this template, try:
1. Modifying it to search other websites
2. Adding features like downloading images
3. Creating your own RPA bots

## 📜 License

This project is open source. You can use, modify, and share it freely.

## 🤝 Contributing

We welcome contributions! Even fixing typos helps!

1. Fork the repository
2. Make your changes
3. Submit a pull request

## 📞 Support

- 📧 Email: [your-email@example.com]
- 💬 Discord: [Your Discord Server]
- 📖 Wiki: [Project Wiki]

---

**Remember:** This is just the beginning! Once you understand this template, you can automate almost any web task. Happy automating! 🚀