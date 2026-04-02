# ``ATLexiconTools/LexiconRegistry``

## Topics

### Initializers

- ``init(lexicons:)``

### Adding and Removing Lexicons

- ``add(lexicon:)``
- ``remove(by:)``

### Retieving Lexicons and Definitions

- ``getLexicon(from:)``
- ``getDefinition(by:types:shouldNormalizeURI:)``

### Validation

- ``validate(lexiconURI:value:)``
- ``validateRecord(by:value:)``
- ``validateXRPCParameters(by:value:)``
- ``validateXRPCMessage(by:)``
- ``validateXRPCInput(by:value:)``
- ``validateXRPCOutput(by:value:)``

### Sequence Instance Methods

- ``makeIterator()``
