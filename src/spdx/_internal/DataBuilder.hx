// SPDX-License-Identifier: Zlib
package spdx._internal;

#if macro
import haxe.Json;
import haxe.ds.StringMap;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import spdx.Exception;
import spdx.License;
import sys.FileSystem;
import sys.io.File;

using Lambda;

typedef LicenseInfo = {
    identifier: String,
    license: License,
};

typedef ExceptionInfo = {
    identifier: String,
    exception: Exception,
};

#end
final class DataBuilder {

    /**
        Generates license objects from `@/data/licenses.json`.
        @return Fields of the built class.
    **/
    public static macro function generateLicenses(): Array<Field> {
    
        final position = Context.currentPos();
        final posInfos = Context.getPosInfos(position);
        final filePath = FileSystem.absolutePath(posInfos.file);
        final dir = Path.normalize(Path.join([filePath, "..", "..", "..", "data"]));
        if (!FileSystem.isDirectory(dir)) {
            Context.error('Directory does not exist: $dir', position);
        }
        
        final json = File.getContent(Path.join([dir, "licenses.json"]));
        final data: Schema.LicenseData = Json.parse(json);
        final licensesByName: StringMap<LicenseInfo> = new StringMap();
        final licenseInfos: Array<LicenseInfo> = data.licenses.map((def) -> {
        
            final identifier = Identifiers.mangleName(def.name, def.isDeprecatedLicenseId);
            final license = new License(
                def.name,
                def.licenseId,
                def.isDeprecatedLicenseId,
                def.isOsiApproved,
                def.isFsfLibre
            );
            
            final licenseInfo: LicenseInfo = {
                identifier: identifier,
                license: license,
            };
            
            final existing = licensesByName.get(license.name);
            if (existing == null || existing.license.isDeprecated) {
                licensesByName.set(license.name, licenseInfo);
            }
            
            return licenseInfo;
        });
        
        final fields = Context.getBuildFields();
        
        for (info in licenseInfos) {
        
            fields.push({
                pos: position,
                name: info.identifier,
                access: [
                    Access.APublic,
                    Access.AStatic,
                    Access.AFinal,
                ],
                meta: if (info.license.isDeprecated) {
                    [Metas.deprecated(position)];
                } else {
                    [];
                },
                doc: '${info.license.name}.',
                kind: FVar(
                    macro : spdx.License,
                    macro new spdx.License(
                        $v{info.license.name},
                        $v{info.license.id},
                        $v{info.license.isDeprecated},
                        $v{info.license.isOsiApproved},
                        $v{info.license.isFsfLibre ?? false}
                    )
                ),
            });
        }
        
        final allByIdExprs: Array<Expr> = [];
        for (info in licenseInfos) {
            allByIdExprs.push(macro $v{info.license.id.toLowerCase()} => $i{info.identifier});
        }
        
        fields.push({
            pos: position,
            name: "__ALL_BY_ID",
            access: [
                Access.APrivate,
                Access.AStatic,
                Access.AFinal,
            ],
            meta: [
                Metas.suppressDeprecated(position)
            ],
            kind: FVar(macro : haxe.ds.StringMap<spdx.License>, macro $a{allByIdExprs}),
        });
        
        fields.push({
            pos: position,
            name: "getById",
            access: [
                Access.APublic,
                Access.AStatic,
            ],
            doc: "Returns the license with the given ID, if one exists.",
            kind: FFun({
                params: [],
                args: [{
                    name: "id",
                    type: macro : String,
                }],
                ret: macro : Null<spdx.License>,
                expr: macro return spdx.License.__ALL_BY_ID.get(id.toLowerCase()),
            })
        });
        
        final allByNameExprs: Array<Expr> = [];
        for (name => info in licensesByName) {
            allByNameExprs.push(macro $v{name} => $i{info.identifier});
        }
        
        fields.push({
            pos: position,
            name: "__ALL_BY_NAME",
            access: [
                Access.APrivate,
                Access.AStatic,
                Access.AFinal,
            ],
            meta: [
                Metas.suppressDeprecated(position)
            ],
            kind: FVar(macro : haxe.ds.StringMap<spdx.License>, macro $a{allByNameExprs}),
        });
        
        fields.push({
            pos: position,
            name: "getByName",
            access: [
                Access.APublic,
                Access.AStatic,
            ],
            doc: "Returns the license with the given name, if one exists.",
            kind: FFun({
                params: [],
                args: [{
                    name: "name",
                    type: macro : String,
                }],
                ret: macro : Null<spdx.License>,
                expr: macro return spdx.License.__ALL_BY_NAME.get(name),
            })
        });
        
        final allExprs: Array<Expr> = [];
        for (info in licenseInfos) {
            allExprs.push(macro $i{info.identifier});
        }
        
        fields.push({
            pos: position,
            name: "ALL",
            access: [
                Access.APublic,
                Access.AStatic,
                Access.AFinal,
            ],
            meta: [
                Metas.suppressDeprecated(position)
            ],
            doc: "Contains all known licenses.",
            kind: FVar(macro : haxe.ds.ReadOnlyArray<spdx.License>, macro $a{allExprs}),
        });
        
        return fields;
    }
    
    /**
        Generates exception objects from `@/data/exceptions.json`.
        @return Fields of the built class.
    **/
    public static macro function generateExceptions(): Array<Field> {
    
        final position = Context.currentPos();
        final posInfos = Context.getPosInfos(position);
        final filePath = FileSystem.absolutePath(posInfos.file);
        final dir = Path.normalize(Path.join([filePath, "..", "..", "..", "data"]));
        if (!FileSystem.isDirectory(dir)) {
            Context.error('Directory does not exist: $dir', position);
        }
        
        final json = File.getContent(Path.join([dir, "exceptions.json"]));
        final data: Schema.ExceptionData = Json.parse(json);
        final exceptionsByName: StringMap<ExceptionInfo> = new StringMap();
        final exceptionInfos: Array<ExceptionInfo> = data.exceptions.map((def) -> {
        
            // Exception names shouldn't collide
            final identifier = Identifiers.mangleName(def.name, false);
            final exception = new Exception(
                def.name,
                def.licenseExceptionId,
                def.isDeprecatedLicenseId
            );
            
            final exceptionInfo: ExceptionInfo = {
                identifier: identifier,
                exception: exception,
            };
            
            final existing = exceptionsByName.get(exception.name);
            if (existing == null || existing.exception.isDeprecated) {
                exceptionsByName.set(exception.name, exceptionInfo);
            }
            
            return exceptionInfo;
        });
        
        final fields = Context.getBuildFields();
        
        for (info in exceptionInfos) {
        
            fields.push({
                pos: position,
                name: info.identifier,
                access: [
                    Access.APublic,
                    Access.AStatic,
                    Access.AFinal,
                ],
                meta: if (info.exception.isDeprecated) {
                    [Metas.deprecated(position)];
                } else {
                    [];
                },
                doc: '${info.exception.name}.',
                kind: FVar(
                    macro : spdx.Exception,
                    macro new spdx.Exception(
                        $v{info.exception.name},
                        $v{info.exception.id},
                        $v{info.exception.isDeprecated},
                    )
                ),
            });
        }
        
        final allByIdExprs: Array<Expr> = [];
        for (info in exceptionInfos) {
            allByIdExprs.push(macro $v{info.exception.id.toLowerCase()} => $i{info.identifier});
        }
        
        fields.push({
            pos: position,
            name: "__ALL_BY_ID",
            access: [
                Access.APrivate,
                Access.AStatic,
                Access.AFinal,
            ],
            meta: [
                Metas.suppressDeprecated(position)
            ],
            kind: FVar(macro : haxe.ds.StringMap<spdx.Exception>, macro $a{allByIdExprs}),
        });
        
        fields.push({
            pos: position,
            name: "getById",
            access: [
                Access.APublic,
                Access.AStatic,
            ],
            doc: "Returns the exception with the given ID, if one exists.",
            kind: FFun({
                params: [],
                args: [{
                    name: "id",
                    type: macro : String,
                }],
                ret: macro : Null<spdx.Exception>,
                expr: macro return spdx.Exception.__ALL_BY_ID.get(id.toLowerCase()),
            })
        });
        
        final allByNameExprs: Array<Expr> = [];
        for (name => info in exceptionsByName) {
            allByNameExprs.push(macro $v{name} => $i{info.identifier});
        }
        
        fields.push({
            pos: position,
            name: "__ALL_BY_NAME",
            access: [
                Access.APrivate,
                Access.AStatic,
                Access.AFinal,
            ],
            meta: [
                Metas.suppressDeprecated(position)
            ],
            kind: FVar(macro : haxe.ds.StringMap<spdx.Exception>, macro $a{allByNameExprs}),
        });
        
        fields.push({
            pos: position,
            name: "getByName",
            access: [
                Access.APublic,
                Access.AStatic,
            ],
            doc: "Returns the exception with the given name, if one exists.",
            kind: FFun({
                params: [],
                args: [{
                    name: "name",
                    type: macro : String,
                }],
                ret: macro : Null<spdx.Exception>,
                expr: macro return spdx.Exception.__ALL_BY_NAME.get(name),
            })
        });
        
        final allExprs: Array<Expr> = [];
        for (info in exceptionInfos) {
            allExprs.push(macro $i{info.identifier});
        }
        
        fields.push({
            pos: position,
            name: "ALL",
            access: [
                Access.APublic,
                Access.AStatic,
                Access.AFinal,
            ],
            meta: [
                Metas.suppressDeprecated(position)
            ],
            doc: "Contains all known exceptions.",
            kind: FVar(macro : haxe.ds.ReadOnlyArray<spdx.Exception>, macro $a{allExprs}),
        });
        
        return fields;
    }
}
