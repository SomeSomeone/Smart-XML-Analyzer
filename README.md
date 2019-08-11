#### Language used
ruby 2.5.5p157 (2019-03-15 revision 67260) [x64-mingw32]

####  Execution 
Tool execution should look like:
`ruby parser.rb <input_origin_file_path> <input_other_sample_file_path> <element_id>` 

Where: 
- `<input_origin_file_path>` - origin sample path to find the element with attribute id="`<element_id>`" and collect all the required information;
- `<input_other_sample_file_path>` - path to diff-case HTML file to search a similar element;
- `<element_id>` - id of element for search, by default "make-everything-ok-button"

#### Exemples of execution:
1) `ruby parser.rb sample-0-origin.html sample-1-evil-gemini.html side-menu`

```
It element seems good
<ul class='nav' id='side-menu'>
                        <li class='sidebar-search'>
                            <div class='input-group custom-search-form'>
                                <input class='form-control' placeholder='Search...' type='text'/>
                                <span class='input-group-btn'>
                                <button class='btn btn-default' type='button'>
                                    <i class='fa fa-search'/>
                                </button>
                            </span>
                            </div>
                            <!-- /input-group -->
                        </li>
                        <li>
                            <a href='index.html'><i class='fa fa-dashboard fa-fw'/> Dashboard</a>
                        </li>
                    </ul>
Because:
The Selector matches 100.0% => 1.0 point(s)
The Name like origin => 1 point(s)
The Text like origin => 1 point(s)
The class like origin => 1 point(s)
The id like origin => 1 point(s)
Selector:
{:name=>"div", :id=>"", :class=>"sidebar-nav navbar-collapse"}
{:name=>"div", :id=>"", :class=>"navbar-default sidebar"}
{:name=>"nav", :id=>"", :class=>"navbar navbar-default navbar-static-top"}
{:name=>"div", :id=>"wrapper", :class=>""}
{:name=>"body", :id=>"", :class=>""}
{:name=>"html", :id=>"", :class=>""}

Process finished with exit code 0
```

2)`ruby parser.rb sample-0-origin.html sample-2-container-and-clone.html`

```
It element seems good
<a class='btn test-link-ok' href='#ok' onclick='javascript:window.okComplete(); return false;' rel='next' title='Make-Button'>
                              Make everything OK
                            </a>
Becose:
The Selector matches 100.0% => 1.0 point(s)
The Name like origin => 1 point(s)
The Text like origin => 1 point(s)
The href like origin => 1 point(s)
The title like origin => 1 point(s)
The rel like origin => 1 point(s)
Selector:
{:name=>"div", :id=>"", :class=>"panel-body"}
{:name=>"div", :id=>"", :class=>"panel panel-default"}
{:name=>"div", :id=>"", :class=>"col-lg-8"}
{:name=>"div", :id=>"", :class=>"row"}
{:name=>"div", :id=>"page-wrapper", :class=>""}
{:name=>"div", :id=>"wrapper", :class=>""}
{:name=>"body", :id=>"", :class=>""}
{:name=>"html", :id=>"", :class=>""}

Process finished with exit code 0
```


