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
    description: "A template for a new feature module",
    attributes: [
        name,
        author,
        currentDate
    ],
    items: [
        
        // MARK: Example app
        
        .item(path: "\(projectPath)/Example", contents: .directory(.relativeToRoot("Tuist/Scaffold/Feature/Example/Sources"))),
        
        .item(path: "\(projectPath)/Example", contents: .directory(.relativeToRoot("Tuist/Scaffold/Feature/Example/Resources"))),
        
        
        // MARK: Tests target
        
        .item(path: "\(projectPath)/Tests/Tests.swift", contents: .file(.relativeToRoot("Tuist/Scaffold/Feature/Tests/Tests.swift"))),
        
        
        // MARK: Feature target
        
        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Tuist/Scaffold/Feature/Feature/Sources"))),
            
//        .item(path: "\(projectPath)/Feature", contents: .directory(.relativeToRoot("Tuist/Scaffold/Feature/Feature/Resources"))),
//        
    
        // MARK: Project.swift
        
        .file(
            path: "\(projectPath)/Project.swift",
            templatePath: .relativeToRoot("Tuist/Scaffold/Feature/Project.stencil")
        ),
    ]
)
