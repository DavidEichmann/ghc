module Rules.CabalHelper (cabalHelperRules) where

import Rules (allStages)
import Development.Shake
import Hadrian.Utilities
import Control.Monad (forM_)
import Data.List (intercalate)
import qualified Settings
import Packages (ghcPackages)
import Context.Path (buildHelperPath)
import Hadrian.Package (pkgCabalFile, pkgName, pkgPath)
import Flavour (packages)

buildHelperFileName :: FilePath
buildHelperFileName = "build.helper"

projectDirVar :: FilePath
projectDirVar = "$PROJECTDIR"

-- TODO generate data only for packages that are built (without forcing build).
cabalHelperRules :: Rules ()
cabalHelperRules = action $ do
    flavour <- Settings.flavour
    buildRoot <- buildRoot

    -- Generate a build.helper file per stage.
    forM_ allStages $ \stage -> do
        pkgs <- packages flavour stage
        writeFile' (buildRoot -/- buildHelperPath stage)
            $ "["
            <> intercalate ",\n"
                (concat [
                    [ "{"
                    , "\"project\": "   <> show (pkgName pkg)
                    , "\"cabalFile\": " <> show (pkgCabalFile pkg)
                    , "\"sourceDir\": " <> show (projectDirVar -/- pkgPath pkg)
                    , "\"distDir\": "   <> show (pkgPath pkg)
                    , "}"
                    ]
                | pkg <- pkgs ])
            <> "]"