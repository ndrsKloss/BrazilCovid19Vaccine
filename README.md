# BrazilCovid19Vaccine

<img src="https://github.com/ndrsKloss/BrazilCovid19Vaccine/blob/master/Images/image03.png" width="19%" height="19%"> 
<img src="https://github.com/ndrsKloss/BrazilCovid19Vaccine/blob/master/Images/image04.png" width="40%" height="40%">

This app shows the current percentage of the vaccination campaign in Brazil and its states. The data is obtained thanks to [covid19br](https://github.com/wcota/covid19br).

The main purpose of this project is to give it a try to widgets, a new iOS 14 feature while using Combine and SwiftUI.

### The learnings

+ Don't name any structure as **State** in your code or it will conflit with `@State` property wrapper.
+ With Combine you will face the need of use a lot of `eraseToAnyPublisher()` function unless you want type the whole variable hard-type like:
```swift
Publishers.ReceiveOn<Publishers.Map<Publishers.ReplaceError<Publishers.TryMap<AnyPublisher<Output, Failure>, Output>>, Output>, DispatchQueue>'
```
+ SwiftUI doesn't provide an easy way to remove the separator line in its UITableView (aka List).

### The problems
+ Why doesn't my List work properly?
+ Confused about the manner I kept the view model in memory using input/output with transform function technique.

### What next
+ Tests

## Authors
+ **Anderson Kloss Maia** - [ndrsKloss](https://github.com/ndrsKloss)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
