# 🤖 OUI Standard RPA Template

A standard model for Robot Proceess Automation using Vibescript.

## 📋 Overview

This RPA template automates the process of extracting Wikipedia articles using Chrome WebDriver.

The created features can be used either through the provided CLI on `release/cli.lua` or by importing the generated library on `release/api_lib.lua`.

In this example, the following actions happen:

1. 🚀 **Initialization**: Sets up ChromeDriver and opens browser session
2. 🔍 **Navigation**: Goes to Wikipedia main page
3. 🔎 **Search**: Enters article name in search box
4. 📰 **Selection**: Clicks on the first search result
5. 📄 **Data Extraction**: Retrieves article content and hatnotes
6. 💾 **Save**: Outputs results to **JSON** file

## 📦 Requirements

- [Darwin](https://github.com/OUIsolutions/Darwin#-installation)
- [VibeScript](https://github.com/ouisolutions/vibescript#-installation)
- Chrome binary (chrome or chromium browser)
- ChromeDriver

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

### Release Bundle Structure

```
└── release/         # Compiled/bundled versions
    ├── cli.lua      # Main CLI interface
    ├── api.lua      # API library
    └── api_lib.lua  # Importable API library
```

## 🛠️ Bundling

> Make sure to have [Darwin](https://github.com/OUIsolutions/Darwin/) installed.

To bundle the code under `api/` and `cli/` just run the following command on the root directory of the project:

```bash
darwin run_blueprint
```

The bundling is done according to what's described in `darwinconf.lua` file.

## 🛠️ Usage

### Command Line Interface

Run the CLI tool with the following required arguments:

```bash
vibescript release/cli.lua --article <article_name> --chromedriver_path <path> --chrome_binary <path> --out_dir <path>
```

### 📝 Available Options

| Option                | Alias | Description                                | Required | Example                                                            |
| --------------------- | ----- | ------------------------------------------ | -------- | ------------------------------------------------------------------ |
| `--article`           | `-a`  | 📰 Name of the Wikipedia article to search | ✅ Yes   | `--article "Machine Learning"`                                     |
| `--chromedriver_path` | `-d`  | 🚗 Path to ChromeDriver executable         | ✅ Yes   | `--chromedriver_path ./chrome-1/chromedriver-linux64/chromedriver` |
| `--chrome_binary`     | `-c`  | 🌐 Path to Chrome/Chromium binary          | ✅ Yes   | `--chrome_binary ./chrome-1/chrome-linux64/chrome`                 |
| `--out_dir`           | `-o`  | 📁 Output directory for results            | ✅ Yes   | `--out_dir "./data"`                                               |

### 💡 Example

```bash
vibescript cli.lua -a "Phreaking" -d "./chrome/chromedriver-linux64/chromedriver" -c "./chrome/chrome-linux64/chrome" -o "./data"
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

## ⚠️ Error Handling

- **Article Not Found**: Returns `nil` if no search results are found
- **Missing Arguments**: Displays error message for required CLI parameters
- **Directory Management**: Automatically creates and cleans output directories

## 🐛 Troubleshooting

- Ensure ChromeDriver version matches your Chrome browser version
- Verify all file paths are correct and accessible
- Check that output directory has write permissions
- Make sure Chrome binary is executable
