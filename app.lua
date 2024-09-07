require 'torch'
require 'nn'
require 'image'

local model = torch.load('model.lua')

local function preprocess_image(img_path)
    local img = image.load(img_path, 3, 'float')
    img = image.scale(img, 150, 150)
    img = img:float()
    return img
end

local function classify_image(img_path)
    local img = preprocess_image(img_path)
    local output = model:forward(img:view(1, 3, 150, 150))
    local _, predicted_class = output:max(2)
    return predicted_class:squeeze():float()
end

-- Example usage (change this path to your image path)
local img_path = 'path_to_your_image.jpg'
local result = classify_image(img_path)
print('Predicted class:', result)
