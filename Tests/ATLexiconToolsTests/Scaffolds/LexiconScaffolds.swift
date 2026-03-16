//
//  LexiconScaffolds.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-07.
//

import Foundation
@testable import ATLexiconTools

func generateLexiconScaffolds() throws -> [Lexicon] {
    var lexicons: [Lexicon] = []

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.kitchenSink",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    description: "A record",
                    key: .tid,
                    record: ATObjectType(
                        properties: [
                            "object" : .reference(ATReferenceType(reference: "#object")),
                            "array" : .array(ATArrayType(items: .string(ATStringType()))),
                            "boolean" : .boolean(ATBooleanType()),
                            "integer" : .integer(ATIntegerType()),
                            "string" : .string(ATStringType()),
                            "bytes" : .bytes(ATBytesType()),
                            "cidLink" : .cidLink(ATCIDLinkType())
                        ],
                        required: ["object", "array", "boolean", "integer", "string", "bytes", "cidLink"]
                    )
                )
            ),
            "object" : .object(
                ATObjectType(
                    properties: [
                        "object" : .reference(ATReferenceType(reference: "#subobject")),
                        "array" : .array(ATArrayType(items: .string(ATStringType()))),
                        "boolean" : .boolean(ATBooleanType()),
                        "integer" : .integer(ATIntegerType()),
                        "string" : .string(ATStringType())
                    ],
                    required: ["object", "array", "boolean", "integer", "string"]
                )
            ),
            "subobject" : .object(
                ATObjectType(
                    properties: [
                        "boolean" : .boolean(ATBooleanType())
                    ],
                    required: ["boolean"]
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.query",
        definitions: [
            "main" : .query(
                QueryDefinition(
                    description: "A query",
                    parameters: ATParamsType(
                        required: ["boolean", "integer"],
                        properties: [
                            "boolean" : .boolean(ATBooleanType()),
                            "integer" : .integer(ATIntegerType()),
                            "string" : .string(ATStringType()),
                            "array" : .array(ATPrimitiveArray(items: .string(ATStringType()))),
                            "def" : .integer(ATIntegerType(defaultValue: 0))
                        ]),
                    output: LexiconHTTPBody(
                        encoding: "application/json",
                        schema: ATReferenceType(
                            reference: "com.example.kitchenSink#object"
                        )
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.procedure",
        definitions: [
            "main" : .procedure(
                ProcedureDefinition(
                    description: "A procedure",
                    parameters: ATParamsType(
                        required: ["boolean", "integer"],
                        properties: [
                            "boolean" : .boolean(ATBooleanType()),
                            "integer" : .integer(ATIntegerType()),
                            "string" : .string(ATStringType()),
                            "array" : .array(ATPrimitiveArray(items: .string(ATStringType())))
                        ]
                    ),
                    output: LexiconHTTPBody(
                        encoding: "application/json",
                        schema: ATReferenceType(reference: "com.example.kitchenSink#object")
                    ),
                    input: LexiconHTTPBody(
                        encoding: "application/json",
                        schema: ATReferenceType(reference: "com.example.kitchenSink#object")
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.optional",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "object" : .reference(ATReferenceType(reference: "com.example.kitchenSink#object")),
                            "array" : .array(ATArrayType(items: .string(ATStringType()))),
                            "boolean" : .boolean(ATBooleanType()),
                            "integer" : .integer(ATIntegerType()),
                            "string" : .string(ATStringType())
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.default",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "boolean" : .boolean(ATBooleanType(defaultValue: false)),
                            "integer" : .integer(ATIntegerType(defaultValue: 0)),
                            "string" : .string(ATStringType(defaultValue: "")),
                            "object" : .reference(ATReferenceType(reference: "#object"))
                        ],
                        required: ["boolean"]
                    )
                )
            ),
            "object" : .object(
                ATObjectType(
                    properties: [
                        "boolean" : .boolean(ATBooleanType(defaultValue: true)),
                        "integer" : .integer(ATIntegerType(defaultValue: 1)),
                        "string" : .string(ATStringType(defaultValue: "x"))
                    ]
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.union",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    description: "A record",
                    key: .tid,
                    record: ATObjectType(
                        properties: [
                            "unionOpen" : .union(
                                ATUnionType(
                                    references: [
                                        "com.example.kitchenSink#object",
                                        "com.example.kitchenSink#subobject"
                                    ]
                                )
                            ),
                            "unionClosed" : .union(
                                ATUnionType(
                                    references: [
                                        "com.example.kitchenSink#object",
                                        "com.example.kitchenSink#subobject"
                                    ],
                                    isClosed: true
                                )
                            )
                        ],
                        required: ["unionOpen", "unionClosed"]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.unknown",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    description: "A record",
                    key: .tid,
                    record: ATObjectType(
                        properties: [
                            "unknown" : .unknown(ATUnknownType()),
                            "optUnknown" : .unknown(ATUnknownType())
                        ],
                        required: ["unknown"]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.arrayLength",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "array" : .array(
                                ATArrayType(items: .integer(ATIntegerType()), minimumLength: 2, maximumLength: 4)
                            )
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.boolConst",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "boolean" : .boolean(ATBooleanType(constant: false))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.integerRange",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "integer" : .integer(ATIntegerType(minimum: 2, maximum: 4))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.integerEnum",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(properties: [
                        "integer" : .integer(ATIntegerType(enumValues: [1, 2]))
                    ])
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.integerConst",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "integer" : .integer(ATIntegerType(constantValue: 0))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.stringLength",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "string" : .string(ATStringType(minimumLength: 2, maximumGraphemes: 4))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.stringLengthGrapheme",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "string" : .string(ATStringType(minimumLength: 2, maximumGraphemes: 4))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.stringEnum",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "string" : .string(ATStringType(enumValues: ["a", "b"]))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.stringConst",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "string" : .string(ATStringType(constantValue: "a"))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.datetime",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "datetime" : .string(ATStringType(format: .dateTime))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.uri",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "uri" : .string(ATStringType(format: .uri))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.atUri",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "atUri" : .string(ATStringType(format: .atURI))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.did",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "did" : .string(ATStringType(format: .did))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.handle",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "handle" : .string(ATStringType(format: .handle))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.atIdentifier",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "atIdentifier" : .string(ATStringType(format: .atIdentifier))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.nsid",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "nsid" : .string(ATStringType(format: .nsid))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.cid",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "cid" : .string(ATStringType(format: .cid))]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.language",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "language" : .string(ATStringType(format: .language))
                        ]
                    )
                )
            )
        ]
    ))

    lexicons.append(try Lexicon(
        lexicon: 1,
        id: "com.example.byteLength",
        definitions: [
            "main" : .record(
                RecordDefinition(
                    record: ATObjectType(
                        properties: [
                            "bytes" : .bytes(ATBytesType(minimumLength: 2, maximumLength: 4))
                        ]
                    )
                )
            )
        ]
    ))

    return lexicons
}
