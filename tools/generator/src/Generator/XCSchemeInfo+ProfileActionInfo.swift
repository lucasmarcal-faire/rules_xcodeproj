import XcodeProj

extension XCSchemeInfo {
    struct ProfileActionInfo {
        let buildConfigurationName: String
        let targetInfo: XCSchemeInfo.TargetInfo
    }
}

// MARK: Host Resolution Initializer

extension XCSchemeInfo.ProfileActionInfo {
    /// Create a copy of the `ProfileActionInfo` with host in the `TargetInfo` resolved.
    init?(
        resolveHostsFor profileActionInfo: XCSchemeInfo.ProfileActionInfo?,
        topLevelTargetInfos: [XCSchemeInfo.TargetInfo]
    ) {
        guard let original = profileActionInfo else {
          return nil
        }
        self.init(
            buildConfigurationName: original.buildConfigurationName,
            targetInfo: .init(
                resolveHostFor: original.targetInfo,
                topLevelTargetInfos: topLevelTargetInfos
            )
        )
    }
}

// MARK: `runnable`

extension XCSchemeInfo.ProfileActionInfo {
    var runnable: XCScheme.BuildableProductRunnable? {
        // We want to provide a `ProfileActionInfo`, but we do not want to set the runnable, if it
        // is testable.
        if targetInfo.pbxTarget.isTestable {
            return nil
        }
        return .init(buildableReference: targetInfo.buildableReference)
    }
}
