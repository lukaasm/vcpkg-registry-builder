param( $registry, $action, $port_name, $features, $extra )

if ( $action -eq "update") {
    $port_destination = "$registry/ports/${port_name}"
    $port_source = "ports/${port_name}"

    git -C ${port_source}/source diff > $port_source/fix_port.patch

    Remove-Item $port_destination -Force -Recurse
    New-Item $port_destination -type directory

    Get-ChildItem $port_source | `
        Where-Object { $_.PSIsContainer -eq $False } | `
        ForEach-Object {Copy-Item -Path $_.Fullname -Destination $port_destination -Force} 

    & "$Env:VCPKG_ROOT\vcpkg.exe" format-manifest "$registry/ports/${port_name}/vcpkg.json"
}

if ( $action -eq "install-static" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$registry/ports $port_name --triplet=x64-windows-static-md
    & "$Env:VCPKG_ROOT\vcpkg.exe" install --classic --overlay-ports=$registry/ports "$port_name[$features]" --triplet=x64-windows-static-md $extra
}

if ( $action -eq "install-shared" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$registry/ports $port_name --triplet=x64-windows
    & "$Env:VCPKG_ROOT\vcpkg.exe" install --classic --overlay-ports=$registry/ports "$port_name[$features]" --triplet=x64-windows $extra
}

if ( $action -eq "remove" ) {
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$registry/ports $port_name --triplet=x64-windows
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$registry/ports $port_name --triplet=x64-windows-static-md
}

if ( $action -eq "commit" ) {
    git -C $registry add ports/$port_name
    git -C $registry commit -m "- ${port_name}: update port $features"

    & "$Env:VCPKG_ROOT\vcpkg.exe" x-add-version --classic --x-builtin-ports-root=$registry/ports --x-builtin-registry-versions-dir=$registry/versions $port_name

    git -C $registry add versions
    git -C $registry commit -m "- ${port_name}: update version"
}