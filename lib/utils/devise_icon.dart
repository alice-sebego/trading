import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

IconData getDeviseIcon(String symbol) {
  switch (symbol) {
    case 'Bitcoin' || 'tBTCUSD':
      return CommunityMaterialIcons.bitcoin;
    case 'Ethereum' || 'tETHUSD':
      return CommunityMaterialIcons.ethereum;
    case 'Ripple' || 'tXRPUSD':
      return CommunityMaterialIcons.hexagon; // xrp
    case 'Tezos' || 'tXTZUSD':
      return CommunityMaterialIcons.currency_eth;
    case 'Polkadot' || 'tDOTUSD':
      return CommunityMaterialIcons.hexagon;
    case 'Litecoin' || 'tLTCUSD':
      return CommunityMaterialIcons.litecoin; // currency_ltc
    case 'Cardano' || 'tADAUSD':
      return CommunityMaterialIcons.card;
    case 'Stellar' || 'tXLMUSD':
      return CommunityMaterialIcons.currency_usd_circle;
    case 'NEO' || 'tNEOUSD':
      return CommunityMaterialIcons.hexagon;
    case 'EOS' || 'tEOSUSD':
      return CommunityMaterialIcons.hexagon;
    default:
      return CommunityMaterialIcons.currency_usd;
  }
}
