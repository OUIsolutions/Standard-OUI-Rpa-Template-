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

## 📝 Requirements

- [Darwin](https://github.com/OUIsolutions/Darwin#-installation)
- [VibeScript](https://github.com/ouisolutions/vibescript#-installation)
- Chrome binary (chrome or chromium browser)
- ChromeDriver

## 📦 Installation

**Download and install** the correct [VibeScript](https://github.com/OUIsolutions/VibeScript/releases/) release for your operational system.
```bash

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

