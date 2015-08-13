# FZValidationTextField

[![Version](https://img.shields.io/cocoapods/v/FZValidationTextField.svg?style=flat)](http://cocoapods.org/pods/FZValidationTextField)
[![License](https://img.shields.io/cocoapods/l/FZValidationTextField.svg?style=flat)](http://cocoapods.org/pods/FZValidationTextField)
[![Platform](https://img.shields.io/cocoapods/p/FZValidationTextField.svg?style=flat)](http://cocoapods.org/pods/FZValidationTextField)


## Screenshots

![Image.png](http://image.yogile.com/yz4btnpu/sevgtycxayd3p801nhd5pa-large.png)


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<strong>using Interface Builder </strong>
<br />
Step 1)  set the class of UITextField to FZValidationTextField

<br />

Step 2)
 	add runtime attribute "validationType":"String" "any validation type like name,email,number," 
 OR
	if you want length validations add runtime attribute "minLength":"Number" or "maxLength":"Number" or you can use both
  OR
	for custom regex you need to use "customMessage" and "customRegex" runtime attributes
<br />

Step 3)
	now you can check as many fields as you want to validate
    NSError *error=[ValidationUtilityMethods validateFields:@[nameField,emailField];

<br />
<br />

<strong>using Programatically </strong>
<br />

you can also create validation fields programmatically
FZValidationTextField *emailField=[FZValidationTextField alloc]init];

now just set validationType and use it as defined above for interface builder usage.




## Installation

FZValidationTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FZValidationTextField"
```




## Author

Faheem, faheemzikeria@gmail.com

## License

FZValidationTextField is available under the MIT license. See the LICENSE file for more info.
