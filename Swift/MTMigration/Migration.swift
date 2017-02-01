import Foundation

public typealias ExecutionClosure = () -> Void

private let MigrationLastVersionKey = "Migration.lastMigrationVersion"
private let MigrationLastAppVersionKey = "Migration.lastAppVersion"

private let MigrationLastBuildKey = "Migration.lastMigrationBuild"
private let MigrationLastAppBuildKey = "Migration.lastAppBuild"

public struct Migration {
    
    static var AppBundle: Bundle = Bundle.main
    
    public static func migrateToVersion(_ version: String, closure: ExecutionClosure) {
        if version.compare(self.lastMigrationVersion, options: [.numeric]) == .orderedDescending &&
            version.compare(self.appVersion, options: [.numeric]) != .orderedDescending {
                closure()
                self.setLastMigrationVersion(version)
        }
    }
    
    public static func migrateToBuild(_ build: String, closure: ExecutionClosure) {
        if build.compare(self.lastMigrationBuild, options: [.numeric]) == .orderedDescending &&
            build.compare(self.appBuild, options: [.numeric]) != .orderedDescending {
                closure()
                self.setLastMigrationBuild(build)
        }
    }
    
    public static func applicationUpdate(_ closure: ExecutionClosure) {
        if self.lastAppVersion != self.appVersion {
            closure()
            self.setLastAppVersion(self.appVersion)
        }
    }
    
    public static func buildNumberUpdate(_ closure: ExecutionClosure) {
        if self.lastAppBuild != self.appBuild {
            closure()
            self.setLastAppBuild(self.appBuild)
        }
    }
    
    public static func reset() {
        self.setLastAppVersion(nil)
        self.setLastMigrationVersion(nil)
        self.setLastAppBuild(nil)
        self.setLastMigrationBuild(nil)
    }
    
    // MARK: - Private methods and properties
    
    fileprivate static var appVersion: String {
        return Migration.AppBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    fileprivate static var appBuild: String {
        return Migration.AppBundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    fileprivate static func setLastMigrationVersion(_ version: String?) {
        UserDefaults.standard.setValue(version, forKey: MigrationLastVersionKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static func setLastMigrationBuild(_ build: String?) {
        UserDefaults.standard.setValue(build, forKey: MigrationLastBuildKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static var lastMigrationVersion: String {
        return UserDefaults.standard.value(forKey: MigrationLastVersionKey) as? String ?? ""
    }
    
    fileprivate static var lastMigrationBuild: String {
        return UserDefaults.standard.value(forKey: MigrationLastBuildKey) as? String ?? ""
    }
    
    fileprivate static func setLastAppVersion(_ version: String?) {
        UserDefaults.standard.setValue(version, forKey: MigrationLastAppVersionKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static func setLastAppBuild(_ build: String?) {
        UserDefaults.standard.setValue(build, forKey: MigrationLastAppBuildKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static var lastAppVersion: String {
        return UserDefaults.standard.value(forKey: MigrationLastAppVersionKey) as? String ?? ""
    }
    
    fileprivate static var lastAppBuild: String {
        return UserDefaults.standard.value(forKey: MigrationLastAppBuildKey) as? String ?? ""
    }
}
