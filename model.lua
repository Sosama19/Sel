local lapis = require("lapis")
local app = lapis.Application()
local torch = require("torch")
local image = require("image")
local nn = require("nn")

-- Load the model
local model = require("model")

-- Serve the HTML form
app:get("/", function()
    return { render = "index" }
end)

-- Handle image classification
app:post("/classify", function(self)
    local file = self.params.file
    if file then
        local img_path = "/app/uploads/" .. file.name
        file:save(img_path)

        -- Classify the image
        local result = classify_image(img_path)
        return { json = { classification = result } }
    else
        return { json = { error = "No file uploaded" } }
    end
end)

-- Preprocess the image
function preprocess_image(img_path)
    local img = image.load(img_path, 3, 'float')
    img = image.scale(img, 150, 150)
    img = img:float()
    return img
end

-- Classify the image
function classify_image(img_path)
    local img = preprocess_image(img_path)
    local output = model:forward(img:view(1, 3, 150, 150))
    local _, predicted_class = output:max(2)
    return predicted_class:squeeze():float()
end

return app
