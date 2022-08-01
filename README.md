#  PayPayCurrencyConversion App
- Usage
    - Convert any money value from one currency to another
    - To run this project we must install pods first
    - Please view 'example_screenshot.png' for result
    
- Approach
    - App Implementation
    
    - Conventions
        - Camel case convention will be followed 
        - All classes should have 'PPC' as suffic
        - All uielement shoul have short prefix eg: Tfld for UITextField
        
    - Limitations
        - Open exchange free version does not allow to change the base currency, thus we'll make call only for USD and do teh currency conversion locally for any other currnecy
        - We'll fetch teh data from APIS only after expiry of currently cached data i.e 30 mins
        
    - Localization : Introduced a localization file and right now support English and Japanese
        
    
- Design
    - Major App Components
        - UI Components
            - PPCCurrencyConverterMainViewController
            - PPCCurrencySelectorWidget
            - PPCAvailableCurrencyList
        - Business Logic containers
        - Models
        - Data Manager
        - Data Providers
            - Cached
            - Network 
    - 
- Architecture
    - SOLID Principles
    - Protocol Driven Development
- Tests
    - Methodology
        - Test only public interfaces
        - Test only interactions between various components
    - Mocks: Used arious mock objects to substitute actual object to break the coupling
- APIs
    - Used open exchange rates reference: https://docs.openexchangerates.org/
    - Flags: https://www.countryflagsapi.com/#howToUse



