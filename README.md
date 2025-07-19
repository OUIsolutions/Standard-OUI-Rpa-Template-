# 🤖 OUI Solutions Standard RPA Template

A standard model for Robot Proceess Automation using Vibescript.

## 📋 Overview

This RPA template automates the process of extracting Wikipedia articles using Chrome WebDriver.

The created features can be used either through the provided CLI on `release/cli.lua` or by importing the generated library on `release/api_lib.lua` on a lua file.

In this example, the following actions happen:

1. 🚀 **Initialization**: Sets up ChromeDriver and opens browser session
2. 🔍 **Navigation**: Goes to main Wikipedia page
3. 🔎 **Search**: Enters article name in search box
4. 📰 **Selection**: Clicks on the first search result
5. 📄 **Data Extraction**: Retrieves article content and hatnotes
6. 💾 **Save**: Outputs results to **JSON** file

## Releases
| Item                                                                                                            | Description                                     | 
|-----------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
|[cli.lua](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/cli.lua)            | Cli to be used in comand line                   |
|[api_lib.lua](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api_lib.lua)    | api to be used with **require** in standard lua |
|[api.lua](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api.lua)            | api to be used embeding in other lua projects   |

## 📝 Requirements

- [Darwin](https://github.com/OUIsolutions/Darwin#-installation)
- [VibeScript](https://github.com/ouisolutions/vibescript#-installation)
- Chrome binary (chrome or chromium browser)
- ChromeDriver

## 📦 Installation

### Step1 : **Download and install** the correct [VibeScript](https://github.com/OUIsolutions/VibeScript/releases/) release for your operational system.
```bash
curl -L https://github.com/OUIsolutions/VibeScript/releases/download/0.15.1/vibescript.out -o vibescript.out && sudo chmod +x vibescript.out && sudo mv vibescript.out /bin/vibescript 
```

### Step2: **Download and install** `chrome` and  `chromedriver`
```bash
# Download ChromeDriver and Chrome
mkdir -p chrome
curl -L https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.94/linux64/chromedriver-linux64.zip -o chromedriver.zip
curl -L https://storage.googleapis.com/chrome-for-testing-public/138.0.7204.94/linux64/chrome-linux64.zip -o chrome-linux64.zip
unzip chromedriver.zip -d chrome && unzip chrome-linux64.zip -d chrome
rm *.zip
```
### Step3: **Download the cli.lua release** from the [releases page](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/tag/0.1.0)
```bash
curl -L https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/cli.lua -o cli.lua
```
### Step4: **Configure alias to vibescript**
```bash
vibescript add_script --file cli.lua wikisearch
```
### Step5: Configure the Chrome paths
```bash
vibescript wikisearch configure --chromedriver_path chrome/chromedriver-linux64/chromedriver --chrome_binary chrome/chrome-linux64/chrome
```
### Step6: **Run the Wikipedia search**
```bash
vibescript wikisearch run --article linux --out_dir teste
```


## 🛠️ Usage

### Command Line Interface

The CLI tool works with two main actions: **configure** and **run**.

#### 1️⃣ First, configure Chrome paths:

```bash
vibescript wikisearch configure --chromedriver_path <path> --chrome_binary <path>
```

#### 2️⃣ Then, run the Wikipedia search:

```bash
vibescript wikisearch run --article <article_name> --out_dir <path>
```

### 📝 Configure Command Options

| Option                | Alias | Description                                | Required | Example                                                       |
| --------------------- | ----- | ------------------------------------------ | -------- | ------------------------------------------------------------- |
| `--chromedriver_path` | `-d`  | 🚗 Path to ChromeDriver executable         | ✅ Yes   | `--chromedriver_path chrome/chromedriver-linux64/chromedriver` |
| `--chrome_binary`     | `-c`  | 🌐 Path to Chrome/Chromium binary          | ✅ Yes   | `--chrome_binary chrome/chrome-linux64/chrome`                |

### 📝 Run Command Options

| Option      | Alias | Description                                | Required | Example                    |
| ----------- | ----- | ------------------------------------------ | -------- | -------------------------- |
| `--article` | `-a`  | 📰 Name of the Wikipedia article to search | ✅ Yes   | `--article "macaco"`       |
| `--out_dir` | `-o`  | 📁 Output directory for results            | ✅ Yes   | `--out_dir "teste"`        |

### 💡 Complete Example

First, configure Chrome paths (only needed once):

```bash
vibescript wikisearch configure --chromedriver_path chrome/chromedriver-linux64/chromedriver --chrome_binary chrome/chrome-linux64/chrome
```

Then search for Wikipedia articles:

```bash
vibescript wikisearch run --article macaco --out_dir teste
```

You can also use shorter aliases:

```bash
vibescript wikisearch configure -d chrome/chromedriver-linux64/chromedriver -c chrome/chrome-linux64/chrome
vibescript wikisearch run -a macaco -o teste
```

## 📤 Output

The program generates the following under the directory specified in the `--out_dir` option:

- 📄 **`result.json`**: Contains extracted article content
- 📁 **`downloads/`**: Directory for any downloaded files

### JSON Structure
```json
{
  "hatnote": "Optional disambiguation or note text from Wikipedia's article",
  "text": "Full article text content"
}
```
## Api Usage 

To use the API, you can import the [`api_lib.lua`](https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api_lib.lua) file in your Lua project:

download the file with:
```bash
curl -L https://github.com/OUIsolutions/Standard-OUI-Rpa-Template-/releases/download/0.1.0/api_lib.lua -o wikisearch.lua 
```

Then, you can use it like this:
```lua

local api = require("wikisearch")


local result = api.fetch_wikipedia_article({
    article = "linux",
    chromedriver_path = "chrome/chromedriver-linux64/chromedriver",
    chrome_binary = "chrome/chrome-linux64/chrome",
    outdir = "teste"
})
print("Hatchnote: " .. (result.hatnote or "No hatnote found"))
print("Article content:"..result.text)

```
run with vibescript:
```bash
vibescript your_lua_file.lua
```


## 📦 Building from scrach
**Download and install** [Darwin](https://github.com/OUIsolutions/Darwin#-installation):

```bash
curl -L https://github.com/OUIsolutions/Darwin/releases/download/0.4.0/darwin.out -o darwin.out && sudo chmod +x darwin.out && sudo mv darwin.out /usr/bin/darwin
```
run the blueprint action, to generate all the **releases** in the **release** dir 
```bash
darwin run_blueprint
```



## ⚠️ Error Handling

- **Article Not Found**: Returns `nil` if no search results are found
- **Missing Arguments**: Displays error message for required CLI parameters
- **Directory Management**: Automatically creates and cleans output directories


## 📁 Project Structure

### Development Structure

All of the code under the `api/` and `cli/` directories is bundled to `release/` through [Darwin](https://github.com/OUIsolutions/Darwin/). This means that the developed code must be in one of the two aforementioned directories, in their respective directory, that is.

```
├── api/             # API modules and source code
│   └── main.lua     # Main public API function
├── cli/             # CLI
│   └── main.lua     # CLI implementation of the API
└── README.md        # This documentation
```

#### `api/scripts.lua`

The file `api/scripts.lua` conttains a JS function to be executed by the webdriver session. This was done in order to get the text content from the article page as it may be extremely large.

Consider using JS functions in such cases.

### Release Bundle Structure

```
└── release/         # Bundled versions
    ├── cli.lua      # Main CLI interface
    ├── api.lua      # API library
    └── api_lib.lua  # Importable API library
```

