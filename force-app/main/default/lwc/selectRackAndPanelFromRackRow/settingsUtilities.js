let getPanelSceneSettings = () => {
    let baseSettings = {
        "environment": {
            "width": 50,
            "height": 50,
            "showGrid": false,
            "gridSize": 60,
            "zoomable": true,
            "movable": true,
            "showAreasAndItems": false,
            "fixAreasToGrid": true,
            "seedStartX": "1",
            "seedStartY": "1",
            "maxWidthOfAreas": "120",
            "spaceBetweenAreas": 1,
            "showMenuBar": false,
            "showLayoutMenu": true,
            "showUserLayoutDrawingMenu": false,
            "showUserAreaLayoutOption": true,
            "areaLayoutLabel": "Draw Area",
            "showUserWallLayoutOption": true,
            "wallLayoutLabel": "Draw Wall",
            "showUserPenLayoutOption": true,
            "showUserDoorsWindowsOption": true,
            "showAreaWallsOption": false,
            "showAreaRoofOption": false,
            "autoAddWallsAndRoof": false,
            "showDataSourceMenu": false,
            "showNextButton": false,
            "showNoteEdit": false,
            "savePlacedItemsOnProceed": false,
            "show3DPreviewButton": false,
            "showFPC": false,
            "callFlowNextOnButtonPressed": false,
            "nextButtonLabel": "Save",
            "nextButtonIcon": "utility:save",
            "allowDropOfItem": true,
            "showPhotoButton": true,
            "showUserRoofingOptions": false,
            "showUserWallInteriorOption": false,
            "showUserWallExteriorOption": false,
            "scale": {
                "x": 0.157,
                "y": 0.157
            },
            "bgImg": "",
            "showComponentInformationOnHover": false,
            "showRelatedRecordDetailsOnHover": true,
            "showFlowOnHover": false,
            "hoverFlowName": "",
            "autoLabel": false,
            "autolabelColumn": "autoNumber",
            "showMeasurements": false,
            "metric": false
        },
        "actions": {
            "canvasChangedFlow": {
                "name": "",
                "visual": false
            },
            "listItemClickedFlow": {
                "name": "",
                "visual": true
            },
            "droppableAreaClickedFlow": {
                "name": "",
                "visual": true
            },
            "draggableItemClickedFlow": {
                "name": "",
                "visual": true
            },
            "dropZoneClicked": {
                "flowname": "",
                "visual": true,
                "standardSelection": true
            },
            "selectableShapeClickedFlow": {
                "name": "",
                "visual": true
            },
            "clickableImageClickedFlow": {
                "name": "",
                "visual": true
            }
        },
        "interactions": [],
        "variables": {
            "name": "menubarText",
            "value": ""
        },
        "droppableAreaTemplates": [
        ],
        "draggableItemTemplates": [
        ],
        "placedDroppableAreas": [],
        "placedDraggableItems": [],
        "placedNotes": [],
        "selectableShapes": [],
        "template": "1.1",
        "layoutElements": {
            "template": "1.0",
            "areas": [],
            "areaElementActions": {
                "dataSourceActions": [
                    {
                        "label": "Elements In Results",
                        "name": "inResult",
                        "steps": []
                    },
                    {
                        "label": "Elements Not In Results",
                        "name": "notInResult",
                        "steps": []
                    }
                ],
                "interactionActions": [
                    {
                        "name": "onClick",
                        "label": "On Click",
                        "steps": []
                    }
                ]
            },
            "walls": [],
            "freeHandShapes": [],
            "environment": {
                "interiorWallColor": "#ffffff",
                "exteriorWallColor": "#F4F3DD",
                "floorColor": "#CDCDCD",
                "interiorWallTex": "",
                "exteriorWallTex": "",
                "roofTextures": [],
                "interiorTex": [],
                "exteriorTex": []
            }
        },
        "dataSource": {
            "id": generateUniqueId(),
            "dataObject": "",
            "fields": [],
            "conditions": {
                "queryLogic": {
                    "conditionRequirement": "and"
                },
                "queryConditions": []
            },
            "groupBy": ""
        },
        "droppedAreas": [],
        "droppedItems": [],
        "additionalDrawings": [],
        "associatedComponents": [],
        "lastSaved": "2025-01-22T23:18:18.674Z",
        "placedSelectableShapes": []
    }
    let panelSizes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60];

    let availabledraggableTemplates = panelSizes.map((itm) => {
        return generateDraggableItemTemplates(itm, true);
    })
    let unavailableDraggableItemTemplates = panelSizes.map((itm) => {
        return generateDraggableItemTemplates(itm, false)
    });
    baseSettings.draggableItemTemplates = [
        ...availabledraggableTemplates,
        ...unavailableDraggableItemTemplates
    ];
    let racksizes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
        51, 52, 53, 54, 55, 56, 57, 58, 59, 60];
    let droppableAreaTemplates = racksizes.map((itm) => { return generateRackDroppableArea(itm); });
    baseSettings.droppableAreaTemplates = droppableAreaTemplates;
    return baseSettings;
}
let images = {
    white: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAFUlEQVR4nGP8//8/A27AhEduBEsDAKXjAxF9kqZqAAAAAElFTkSuQmCC",
    yellow: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAE0lEQVR4nGP8/58BD2DCJzlypQF0BwISHGyJPgAAAABJRU5ErkJggg==",
    black: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKAQAAAAClSfIQAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QAAd2KE6QAAAAHdElNRQfpAgISJTD83uxUAAAAC0lEQVQI12NgwAcAAB4AAW6FRzIAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjUtMDItMDJUMTg6Mzc6NDgrMDA6MDC/lr1eAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDI1LTAyLTAyVDE4OjM3OjQ4KzAwOjAwzssF4gAAAABJRU5ErkJggg==",

}
const generateDraggableItemTemplates = (uSize, available = false) => {
    let label = uSize + (available ? "-Available" : "-Unavailable");
    let color = available ? images.white : images.yellow;
    return {
        "imageURL": color,
        "width": 10,
        "height": uSize,
        "id": generateUniqueId(),
        "listLabel": label,
        "name": label,
        "labelText": "",
        "labelColor": "",
        "labelTextColor": "",
        "removable": false,
        "record": {
            "recordId": "",
            "sobject": "DC_Panel__c",
            "uniqueField": "",
            "uniqueFieldValue": ""
        },
        "modelURL": "",
        "scaleX": 1,
        "scaleY": 1,
        "scaleZ": 1,
        "transformX": 0,
        "transformY": 0,
        "transformZ": 0,
        "filters": {
            "red": 0,
            "green": 0,
            "blue": 0
        },
        "group": "",
        "template": "1.0"
    }
}
const generateRackDroppableArea = (uheight) => {
    return {
        "width": 11,
        "height": uheight + 2,
        "depth": 1,
        "imageURL": images.black,
        "name": uheight + "U",
        "id": generateUniqueId(),
        "x": 0,
        "y": 0,
        "z": 0,
        "listLabel": "Rack " + uheight,
        "allowItemOverlap": false,
        "enableSorting": true,
        "droppableItemTypes": [],
        "draggable": true,
        "removable": false,
        "padLeft": 30,
        "padTop": 60,
        "padRight": 30,
        "padBottom": 60,
        "itemsAlign": "end",
        "record": {
            "recordId": "",
            "sobject": "",
            "uniqueField": "",
            "uniqueFieldValue": ""
        },
        "recordId": "",
        "dropZones": [],
        "group": "",
        "template": "1.0"
    }
}
const generateUniqueId = () => {
    var d = new Date().getTime();
    var d2 = (performance && performance.now && (performance.now() * 1000)) || 0; //Time in microseconds since page-load or 0 if unsupported
    var rcontextId = 'x-xxxx-4xx-yxxx-xx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16;
        if (d > 0) {
            r = (d + r) % 16 | 0;
            d = Math.floor(d / 16);
        } else {
            r = (d2 + r) % 16 | 0;
            d2 = Math.floor(d2 / 16);
        }
        return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
    });
    return rcontextId;
}
export { getPanelSceneSettings, generateUniqueId };