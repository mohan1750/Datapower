let json = {
    "menu": {
        "id": "file",
        "value": "File",
        "popup": {
            "menuitem": [
                { "value": "New", "onclick": "CreateNewDoc()" },
                { "value": "Open", "onclick": "OpenDoc()" },
                { "value": "Close", "onclick": "CloseDoc()" }
            ],
            "items": ['Hi',"Bro"]
        }
    }
}
function parseLiteral(value) {
    let newkey = {}
    newkey.$ = value
    return newkey
}
function parseObject(object) {
    let output = {}
    Object.keys(object).forEach(element => {
        if( typeof object[element] !== 'object') {
            let newkey = parseLiteral(object[element])
            output[element] = newkey
        } else if (Array.isArray(object[element])) {
                output[element] = parseArray(object[element])
        } else {
            output[element] = parseObject(object[element])
        }
    })
    return output
}
function parseArray(list){
    let items = []
    list.forEach(item => {
        if(typeof item === 'object') {
            let newItem = parseObject(item)
            items.push(newItem)
        } else {
            items.push(parseLiteral(item))
        }
    })
    return items
}
function generateJson(req) {
    if(Array.isArray(req)) {
        return parseArray(req)
    } else {
        return parseObject(req)
    }
}
console.log(JSON.stringify(generateJson(json)))