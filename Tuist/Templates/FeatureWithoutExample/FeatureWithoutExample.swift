//
//  Templates/Feature.swift
//
//

import Foundation
import ProjectDescription

private let name: Template.Attribute = .required("name")
private let author: Template.Attribute = .required("author")
private let currentDate: Template.Attribute = .required("currentDate")

let projectPath = "Projects/Feature/\(name)"

let featureTemplate = Template(
    description: "A template for a new feature module without example",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        
        // MARK: Tests target
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Tuist/Scaffold/FeatureWithoutExample/Tests/Tests.swift"))),
        
        
        // MARK: Feature target
        
        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Tuist/Scaffold/FeatureWithoutExample/Feature/Sources"))),
            
    
        // MARK: Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Tuist/Scaffold/FeatureWithoutExample/Project.stencil")
        ),
    ]
)
