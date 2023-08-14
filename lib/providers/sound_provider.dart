import 'package:flutter/widgets.dart';
import 'package:soundpool/soundpool.dart';

/// Adding this provider in your Widgets tree will load the pre-defined
/// [SoundEffects]. In any of it's children, you can play the sound effect
/// Examples
///
/// ```dart
/// final SoundProvider sound = SoundProvider.of(context);
///
/// await sound.ask.play();
/// await sound.click.play();
/// await sound.error.play();
/// await sound.deploy.play();
/// await sound.typing.play();
/// await sound.warning.play();
/// await sound.typingLong.play();
/// await sound.information.play();
/// ```
class SoundProvider extends StatefulWidget {
  const SoundProvider({
    Key key,
    required this.child,
    this.streamType = StreamType.notification,
  })  : assert(streamType != null),
        super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  /// [streamType] parameter has effect on Android only.
  final StreamType streamType;

  @override
  _SoundProviderState createState() => _SoundProviderState();

  static SoundEffects of(BuildContext context) {
    final _SoundProviderInherited provider = context
        ?.getElementForInheritedWidgetOfExactType<_SoundProviderInherited>()
        ?.widget;

    return provider.sounds;
  }
}

class _SoundProviderState extends State<SoundProvider> {
  Soundpool _pool;
  SoundEffects _sounds;

  @override
  void initState() {
    super.initState();

    _pool ??= Soundpool(streamType: widget.streamType);
    _sounds ??= SoundEffects({
      SoundEffect.ask: Sound(pool: _pool, id: _load('ask')),
      SoundEffect.click: Sound(pool: _pool, id: _load('click')),
      SoundEffect.error: Sound(pool: _pool, id: _load('error')),
      SoundEffect.deploy: Sound(pool: _pool, id: _load('deploy')),
      SoundEffect.typing: Sound(pool: _pool, id: _load('typing')),
      SoundEffect.warning: Sound(pool: _pool, id: _load('warning')),
      SoundEffect.typingLong: Sound(pool: _pool, id: _load('typing_long')),
      SoundEffect.information: Sound(pool: _pool, id: _load('information')),
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pool.dispose();
  }

  Future<int> _load(String sound) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data =
        await assetBundle.load('packages/vizor/assets/sounds/$sound.mp3');
    return _pool.load(data);
  }

  @override
  Widget build(BuildContext context) {
    return _SoundProviderInherited(
      pool: _pool,
      sounds: _sounds,
      child: widget.child,
    );
  }
}

class _SoundProviderInherited extends InheritedWidget {
  const _SoundProviderInherited({
    Key key,
    required this.pool,
    required this.sounds,
    required Widget child,
  }) : super(key: key, child: child);

  final Soundpool pool;
  final SoundEffects sounds;

  @override
  bool updateShouldNotify(_SoundProviderInherited oldWidget) => false;
}

enum SoundEffect {
  ask,
  click,
  error,
  deploy,
  typing,
  warning,
  typingLong,
  information,
}

class SoundEffects {
  const SoundEffects(Map<SoundEffect, Sound> sounds) : _sounds = sounds;

  final Map<SoundEffect, Sound> _sounds;

  Sound get ask => _sounds[SoundEffect.ask];
  Sound get click => _sounds[SoundEffect.click];
  Sound get error => _sounds[SoundEffect.error];
  Sound get deploy => _sounds[SoundEffect.deploy];
  Sound get typing => _sounds[SoundEffect.typing];
  Sound get warning => _sounds[SoundEffect.warning];
  Sound get typingLong => _sounds[SoundEffect.typingLong];
  Sound get information => _sounds[SoundEffect.information];

  Sound get(SoundEffect sound) => _sounds[sound];
}

class Sound {
  const Sound({required pool, required this.id}) : _pool = pool;

  final Soundpool _pool;
  final Future<int> id;

  /// Plays the current loaded sound.
  /// Returns a [SoundStream] to further control the playback.
  ///
  /// `rate` has to be value in (0.5 - 2.0) range
  ///
  /// ```dart
  /// final SoundProvider sound = SoundProvider.of(context);
  /// await sound.typingLong.play(repeat: 100);
  Future<void> play({double rate = 1.0}) async {
    await _pool.play(await id, rate: rate);
  }
}
