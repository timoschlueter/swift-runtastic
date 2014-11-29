#Swift Runtastic

Swift Runtastic is a class to gain easy access to Runtastic ([www.runtastic.com](http://www.runtastic.com)) activity data through Swift.
This is a very dirty approach since Runtastic doesn't offer an official API. Port of [php-runtastic](https://github.com/timoschlueter/php-runtastic).



##Methods
------
#### setUsername(userName: String)

**[Mandatory]** Sets the username used for logging into Runtastic

#### setPassword(password: String)

**[Mandatory]** Sets the password used for logging into Runtastic

#### getRuntasticActivities()

Fetches and prints all the data. See "Output" for details.


##Example
This is an example which logs into runtastic, fetches every activity in your account and outputs internal Runtastic data (Username, UID) and a simple string.


#### Usage

```
	import UIKit

	class ViewController: UIViewController {

	    override func viewDidLoad() {
	        super.viewDidLoad()
	        // Do any additional setup after loading the view, typically from a nib.
	        
	        var myRuntastic: Runtastic = Runtastic()
	        myRuntastic.setUsername("E-MAIL")
	        myRuntastic.setPassword("PASSWORD")
	        myRuntastic.getRuntasticActivities()
	    }

	    override func didReceiveMemoryWarning() {
	        super.didReceiveMemoryWarning()
	        // Dispose of any resources that can be recreated.
	    }
	}
```
	
#### Output

```
This is what a typical activity object looks like:

Logged in with mail@example.com

Session-URL: https://www.runtastic.com/en/users/firstname-lastname/sport-sessions/

UID: 47111337

Token: JjkAF88asfjKAkKFJkgjksdllLASj99=

-- ACTIVITY DATA AS JSON --
```

License
-------

The MIT License (MIT)

Copyright (c) 2014 Timo Schlueter <timo.schlueter@me.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
