SELECT record::id((->imageAsset->asset.id)[0]) AS iaid FROM $asset;
