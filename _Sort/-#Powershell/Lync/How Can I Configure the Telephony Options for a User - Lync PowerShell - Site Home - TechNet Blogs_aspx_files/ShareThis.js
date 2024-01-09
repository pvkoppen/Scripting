//Executes the function when the DOM is ready to be used
//ShowMoreLessButtonsPanel - div with two buttons More Less
function ShowMoreLessButtonsPanelOnClick()
{
    jQuery('.msdntechnet-socialmediasharing .tierTwoPanel').toggle();
    jQuery(".msdntechnet-socialmediasharing .btnMore").toggle();
    jQuery(".msdntechnet-socialmediasharing .btnLess").toggle();
    return;
}

//timer = 3000;
var mouseIn = false;

//ShowMoreLessButtonsPanel - div with two buttons More Less
function ShowMoreLessButtonsPanelOnmouseOver()
{
    mouseIn = true;
    return;
}

function ShowMoreLessButtonsPanelOnmouseOut()
{
    var slidinPanel = jQuery('.msdntechnet-socialmediasharing .tierTwoPanel').css('display');
    if (slidinPanel != 'none')
    {
        if (mouseIn == false)
        {
            setTimeout(function ()
            {
                ShowMoreLessButtonsPanelOnClick();
            }, 3000);
        }
    }

    return;
}

//ShareThisChildRootPanel
function ShareThisChildRootPanelOnmouseOver()
{
    mouseIn = true;
    return;
}
function ShareThisChildRootPanelOnmouseOut()
{
    mouseIn = false;
    return;
}
//TierTwoPanel
function TierTwoPanelOnclick() { return; }

function TierTwoPanelOnmouseOver()
{
    mouseIn = true;
    return;
}
function TierTwoPanelOnmouseOut()
{
    mouseIn = false;
    return;
}