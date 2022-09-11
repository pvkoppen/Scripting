function rowShader(id)
{

	if (document.getElementsByTagName)
	{
    var dataTables;
    var table;
    var rows;

    dataTables = getElementsByClassName(document.body, 'dataTable');
    if (dataTables.length == 0)
    {
      return;
    };

    for (i = 0; i < dataTables.length; i++)
    {
      table = getElementsByClassName(document.body, 'dataTable')[i];
      rows = table.getElementsByTagName("tr");

      for (j = 0; j < rows.length; j++)
      {
        if (j % 2 == 0)
        {
          rows[j].className = "even";
        }
        else
        {
          rows[j].className = "odd";
        };
      };
    };
	};

}

//	-----------------------------------------------------------------------

function getElementsByClassName(anElement, className)
{
	var		allElements;
	var		classNameMatch;
	var		i;
	var		results;

	allElements = anElement.getElementsByTagName('*');

	classNameMatch = new RegExp("(^|\\s)" + className + "(\\s|$)");

	results = [];

	for (i = 0; i < allElements.length; i++)
	{
		if (classNameMatch.test(allElements[i].className) == true)
		{
			results.push(allElements[i]);
		};
	};

	return results;
};

addEvent(window,'load',function () {rowShader('dataTable')});
