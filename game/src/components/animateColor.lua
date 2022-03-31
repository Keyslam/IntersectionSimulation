ECS.component("animateColor", function(e, oldColor, newColor, animationDuration)
    e.oldColor = oldColor
    e.newColor = newColor

    e.animationTime = 0
    e.animationDuration = animationDuration
end)