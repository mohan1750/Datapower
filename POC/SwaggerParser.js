const fileUtils = require('./files')
const filepath = require('path')

const getCurrentDate = () => {
    var date_ob = new Date();
    var day = ("0" + date_ob.getDate()).slice(-2);
    var month = ("0" + (
        date_ob.getMonth() + 1
    )).slice(-2);
    var year = date_ob.getFullYear();

    var date = year + "-" + month + "-" + day;
    return date
}
const getCurrentTime = () => {
    var date_ob = new Date();
    
    var hours = ("0" + date_ob.getHours()).slice(-2);
    var minutes = ("0" + date_ob.getMinutes()).slice(-2);
    var seconds = ("0" + date_ob.getSeconds()).slice(-2);
    var time = hours + ":" + minutes + ":" + seconds;
    return time
}
const getAllOperationPaths = (json) => {
    let operationPaths = []
    let Paths = json.paths
    Object.keys(Paths).forEach(key => {
        let operation = Paths[key]
        Object.keys(operation).forEach(key2 => {
            let methodInfo = operation[key2]
            operationPaths.push({
                path: key,
                method: key2,
                ... methodInfo
            })
        })
    })
    return operationPaths
}
const filterParams = (operation, type) => {
    return operation.parameters.filter((entry) => entry.in === type)

}
const getParamValue = (param) => {
    if (typeof param !== undefined && typeof param === 'object' && !Array.isArray(param)) {
        if (param['x-example'] !== undefined || param['example'] !== undefined) 
            return param['x-example'] || param['example']
         else if (param.type === 'string' && param.format === 'date') 
            return getCurrentDate()
         else if (param.type === 'string' && param.format === 'time') 
            return getCurrentTime()
         else if (param.type === 'string' && param.format === 'date-time') 
            return `${getCurrentDate()}T${getCurrentTime()}.000Z`      
         else if (param.type === 'string') 
            return 'string'
         else if (param.type === 'boolean') 
            return true
         else if (param.type === 'integer' || param.type === 'number') 
            return 0
    }
}
const generateObject = (obj) => {
    let res = {}
    Object.keys(obj).forEach(key => {
        if (obj[key].type === 'array') {
            res[key] = generateArray(obj[key])
        } else if (obj[key].type === 'object') {
            res[key] = generateObject(obj[key].properties)
        } else {
            res[key] = getParamValue(obj[key])
        }
       
    })
    return res
}
const generateArray = (arr) => {
    let list = []
        if (arr.items.type === 'object') {
            list.push(generateObject(arr.items.properties))
        } else {
            list.push(getParamValue(arr.items))
        }
        return list
}
const generateBody = (data) => {
    if(data.schema.type === 'object') {
        return generateObject(data.schema.properties)
    } else if (data.schema.type === 'array') {
        return generateArray(data.schema.items)
        
    } else {
        return getParamValue(data.schema)
    }
}
module.exports.generateTestCases = (json, gateway= '') => {
    let entries = getAllOperationPaths(json)
    entries.forEach(entry => { // console.log(entry.parameters)
        let {
            operationId,
            path,
            method,
            responses
        } = entry
        // Generate Folders for each OperationID
        const filePath = filepath.resolve(__dirname, `../test/${
            json.info.title
        }`, json.info.version, operationId)
        fileUtils.createDir(filePath)
        let swagHeaders = filterParams(entry, 'header')
        let swagQueryParams = filterParams(entry, 'query')
        let swagPathParams = filterParams(entry, 'path')
        let swagPayload = filterParams(entry, 'body')
        let reqheaders = {}
        let queryParams = {}
        let pathparams = {}

        swagHeaders.forEach(header => {
            reqheaders[header.name] = getParamValue(header)
        })
        if(gateway === 'apic') reqheaders['x-ibm-client-id'] = '<Replace Value>'
        else if(gateway === 'apimesh') reqheaders['client_id'] = '<Replace Value>'
        swagQueryParams.forEach(query => {
            queryParams[query.name] = getParamValue(query)
        })
        swagPathParams.forEach(path => {
            pathparams[path.name] = getParamValue(path)
        })
        let data = {
            headers: reqheaders,
            query: queryParams,
            method,
        }
        if(Object.keys(pathparams).length > 0) {
            let uri = ''

            Object.keys(pathparams).forEach(param => {
                uri = path.substring(0,path.indexOf(param)-1)+ pathparams[param]+ path.substring(path.indexOf(param)+(param.length+1))
            })
            data.uri = uri
        }
        if(swagPayload.length !== 0) {
            let payloadSchema = swagPayload[0]
            data.body = JSON.stringify(generateBody(payloadSchema))  
        }
        fileUtils.writeToFile(`${filePath}/tests.json`, data)
        })
}
