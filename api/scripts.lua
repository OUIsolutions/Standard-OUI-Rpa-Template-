
PrivateApi.get_all_text = [[ 
return (function getAllTextFromElement(element) {
            let text = "";
            for (let child of element.childNodes) {
                if (child.nodeType === Node.TEXT_NODE) {
                    text += child.textContent + " ";
                } else if (child.nodeType === Node.ELEMENT_NODE) {
                    text += getAllTextFromElement(child) + " ";
                }
            }
            return text.trim();
})
]]