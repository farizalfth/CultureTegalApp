import 'package:flutter/material.dart';

class IconMapping {
  static IconData getIcon(String key) {
    final String cleanKey = key.toLowerCase().trim();

    switch (cleanKey) {
      case 'ibadah':
      case 'tempat_ibadah':
      case 'spiritual':
        return Icons.maps_home_work_rounded;
      case 'mosque':
      case 'masjid':
      case 'mushola':
        return Icons.mosque_rounded;
      case 'church':
      case 'gereja':
        return Icons.church_rounded;
      case 'temple':
      case 'vihara':
      case 'pura':
      case 'candi':
        return Icons.temple_hindu_rounded;
      case 'parking':
      case 'parkir':
      case 'transportasi':
        return Icons.local_parking_rounded;
      case 'toilet':
      case 'kamar_mandi':
      case 'mck':
        return Icons.wc_rounded;
      case 'restaurant':
      case 'kuliner':
      case 'warung':
      case 'makan':
        return Icons.restaurant_rounded;
      case 'camera':
      case 'spot_foto':
      case 'selfie':
        return Icons.local_see_rounded;
      case 'store':
      case 'toko':
      case 'souvenir':
      case 'umkm':
        return Icons.storefront_rounded;
      case 'wifi':
      case 'internet':
        return Icons.wifi_rounded;
      case 'atm':
      case 'keuangan':
      case 'bank':
        return Icons.local_atm_rounded;
      case 'wheelchair':
      case 'disabilitas':
      case 'aksesibilitas':
        return Icons.accessible_rounded;
      case 'info':
      case 'informasi':
      case 'panduan':
        return Icons.info_rounded;
      case 'medical':
      case 'kesehatan':
      case 'klinik':
      case 'p3k':
        return Icons.medical_services_rounded;
      case 'security':
      case 'keamanan':
      case 'polisi':
        return Icons.security_rounded;
      case 'ticket':
        return Icons.local_activity_rounded;
      case 'charging':
      case 'cas_hp':
        return Icons.power_rounded;
      case 'recreation':
      case 'playground':
      case 'bermain':
        return Icons.child_care_rounded;
      case 'nature':
        return Icons.terrain_rounded;
      case 'rest_area':
      case 'saung':
      case 'gazebo':
      case 'pendopo':
        return Icons.roofing_rounded;
      case 'museum':
      case 'sejarah':
      case 'monumen':
        return Icons.museum_rounded;
      case 'cleanliness':
      case 'sampah':
      case 'kebersihan':
        return Icons.delete_outline_rounded;
      case 'no_entry':
      case 'larangan':
      case 'regulasi':
        return Icons.do_not_disturb_on_total_silence_rounded;
      case 'guide':
        return Icons.record_voice_over_rounded;
      case 'locker':
        return Icons.lock_rounded;
      case 'hotel':
      case 'penginapan':
      case 'homestay':
        return Icons.hotel_rounded;
      case 'pool':
      case 'swimming':
      case 'pemandian':
        return Icons.pool_rounded;
      case 'shower':
      case 'kamar_bilas':
      case 'ruang_ganti':
        return Icons.shower_rounded;
      case 'shuttle':
      case 'mobil_wisata':
      case 'transport_lokal':
        return Icons.airport_shuttle_rounded;
      case 'camping':
      case 'campground':
      case 'kemah':
        return Icons.local_fire_department;
      case 'garden':
      case 'taman_bunga':
      case 'agro':
        return Icons.local_florist_rounded;
      case 'fauna':
      case 'hewan':
      case 'pets_allowed':
        return Icons.pets_rounded;
      case 'library':
      case 'buku':
      case 'perpustakaan':
        return Icons.local_library_rounded;
      case 'viewpoint':
      case 'gardu_pandang':
      case 'puncak':
        return Icons.visibility_rounded;
      case 'stage':
      case 'panggung':
      case 'live_music':
        return Icons.mic_external_on_rounded;
      case 'boat':
      case 'perahu':
      case 'dermaga':
        return Icons.directions_boat_rounded;
      case 'bridge':
      case 'jembatan':
        return Icons.architecture_rounded;
      case 'adventure':
      case 'outbound':
      case 'flying_fox':
        return Icons.explore_rounded;
    }

    if (cleanKey.contains('ibadah') ||
        cleanKey.contains('religi') ||
        cleanKey.contains('spiritual') ||
        cleanKey.contains('sholat') ||
        cleanKey.contains('doa') ||
        cleanKey.contains('sembahyang') ||
        cleanKey.contains('mushola') ||
        cleanKey.contains('worship') ||
        cleanKey.contains('altar') ||
        cleanKey.contains('kuil')) {
      return Icons.maps_home_work;
    }

    if (cleanKey.contains('parkir') ||
        cleanKey.contains('transport') ||
        cleanKey.contains('kendaraan') ||
        cleanKey.contains('mobil') ||
        cleanKey.contains('motor') ||
        cleanKey.contains('bus') ||
        cleanKey.contains('stasiun')) {
      return Icons.local_parking_rounded;
    }

    if (cleanKey.contains('toilet') ||
        cleanKey.contains('mandi') ||
        cleanKey.contains('washroom') ||
        cleanKey.contains('wc') ||
        cleanKey.contains('mck')) {
      return Icons.wc_rounded;
    }

    if (cleanKey.contains('makan') ||
        cleanKey.contains('food') ||
        cleanKey.contains('minum') ||
        cleanKey.contains('drink') ||
        cleanKey.contains('kuliner') ||
        cleanKey.contains('resto') ||
        cleanKey.contains('warung') ||
        cleanKey.contains('cafe')) {
      return Icons.restaurant_rounded;
    }

    if (cleanKey.contains('toko') ||
        cleanKey.contains('shop') ||
        cleanKey.contains('market') ||
        cleanKey.contains('souvenir') ||
        cleanKey.contains('oleh') ||
        cleanKey.contains('umkm')) {
      return Icons.storefront_rounded;
    }

    if (cleanKey.contains('foto') ||
        cleanKey.contains('photo') ||
        cleanKey.contains('kamera') ||
        cleanKey.contains('camera') ||
        cleanKey.contains('selfie') ||
        cleanKey.contains('gambar')) {
      return Icons.local_see_rounded;
    }

    if (cleanKey.contains('sehat') ||
        cleanKey.contains('medis') ||
        cleanKey.contains('medical') ||
        cleanKey.contains('klinik') ||
        cleanKey.contains('obat') ||
        cleanKey.contains('p3k') ||
        cleanKey.contains('sakit')) {
      return Icons.medical_services_rounded;
    }

    if (cleanKey.contains('aman') ||
        cleanKey.contains('security') ||
        cleanKey.contains('polisi') ||
        cleanKey.contains('jaga') ||
        cleanKey.contains('pemadam')) {
      return Icons.security_rounded;
    }

    if (cleanKey.contains('alam') ||
        cleanKey.contains('nature') ||
        cleanKey.contains('curug') ||
        cleanKey.contains('danau') ||
        cleanKey.contains('gunung') ||
        cleanKey.contains('hutan') ||
        cleanKey.contains('pantai')) {
      return Icons.terrain_rounded;
    }

    if (cleanKey.contains('istirahat') ||
        cleanKey.contains('saung') ||
        cleanKey.contains('gazebo') ||
        cleanKey.contains('pendopo') ||
        cleanKey.contains('bangku') ||
        cleanKey.contains('lesehan')) {
      return Icons.roofing_rounded;
    }

    if (cleanKey.contains('hotel') ||
        cleanKey.contains('tidur') ||
        cleanKey.contains('penginapan') ||
        cleanKey.contains('homestay') ||
        cleanKey.contains('losmen') ||
        cleanKey.contains('vila') ||
        cleanKey.contains('resort')) {
      return Icons.hotel_rounded;
    }

    if (cleanKey.contains('pool') ||
        cleanKey.contains('renang') ||
        cleanKey.contains('pemandian') ||
        cleanKey.contains('kolam') ||
        cleanKey.contains('belerang') ||
        cleanKey.contains('terapi')) {
      return Icons.pool_rounded;
    }

    if (cleanKey.contains('shower') ||
        cleanKey.contains('bilas') ||
        cleanKey.contains('ganti') ||
        cleanKey.contains('pancuran')) {
      return Icons.shower_rounded;
    }

    if (cleanKey.contains('shuttle') ||
        cleanKey.contains('kelinci') ||
        cleanKey.contains('jemput') ||
        cleanKey.contains('mobil_wisata') ||
        cleanKey.contains('angkot')) {
      return Icons.airport_shuttle_rounded;
    }

    if (cleanKey.contains('camping') ||
        cleanKey.contains('kemah') ||
        cleanKey.contains('tenda') ||
        cleanKey.contains('campground')) {
      return Icons.local_fire_department;
    }

    if (cleanKey.contains('garden') ||
        cleanKey.contains('taman_bunga') ||
        cleanKey.contains('agro') ||
        cleanKey.contains('kebun') ||
        cleanKey.contains('florist')) {
      return Icons.local_florist_rounded;
    }

    if (cleanKey.contains('fauna') ||
        cleanKey.contains('hewan') ||
        cleanKey.contains('pets') ||
        cleanKey.contains('satwa') ||
        cleanKey.contains('zoo') ||
        cleanKey.contains('rusa')) {
      return Icons.pets_rounded;
    }

    if (cleanKey.contains('buku') ||
        cleanKey.contains('baca') ||
        cleanKey.contains('library') ||
        cleanKey.contains('perpustakaan') ||
        cleanKey.contains('literasi')) {
      return Icons.local_library_rounded;
    }

    if (cleanKey.contains('lihat') ||
        cleanKey.contains('view') ||
        cleanKey.contains('puncak') ||
        cleanKey.contains('teropong') ||
        cleanKey.contains('gardu') ||
        cleanKey.contains('pandang')) {
      return Icons.visibility_rounded;
    }

    if (cleanKey.contains('musik') ||
        cleanKey.contains('panggung') ||
        cleanKey.contains('stage') ||
        cleanKey.contains('hiburan') ||
        cleanKey.contains('konser') ||
        cleanKey.contains('sing')) {
      return Icons.mic_external_on_rounded;
    }

    if (cleanKey.contains('perahu') ||
        cleanKey.contains('boat') ||
        cleanKey.contains('dermaga') ||
        cleanKey.contains('kapal') ||
        cleanKey.contains('arung') ||
        cleanKey.contains('dayung')) {
      return Icons.directions_boat_rounded;
    }

    if (cleanKey.contains('jembatan') ||
        cleanKey.contains('bridge') ||
        cleanKey.contains('penyeberangan') ||
        cleanKey.contains('lintas')) {
      return Icons.architecture_rounded;
    }

    if (cleanKey.contains('petualang') ||
        cleanKey.contains('adventure') ||
        cleanKey.contains('outbound') ||
        cleanKey.contains('flying') ||
        cleanKey.contains('fox') ||
        cleanKey.contains('tantangan')) {
      return Icons.explore_rounded;
    }

    if (cleanKey.contains('bengkel') ||
        cleanKey.contains('tool') ||
        cleanKey.contains('repair') ||
        cleanKey.contains('mekanik') ||
        cleanKey.contains('service')) {
      return Icons.build_rounded;
    }

    if (cleanKey.contains('gedung') ||
        cleanKey.contains('building') ||
        cleanKey.contains('kantor') ||
        cleanKey.contains('office') ||
        cleanKey.contains('instansi') ||
        cleanKey.contains('balai')) {
      return Icons.business_rounded;
    }

    return Icons.room_service_rounded;
  }
}