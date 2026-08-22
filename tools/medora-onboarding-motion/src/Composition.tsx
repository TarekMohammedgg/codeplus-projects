import {
  AbsoluteFill,
  Composition,
  Easing,
  Img,
  interpolate,
  staticFile,
  useCurrentFrame,
} from "remotion";

type IllustrationProps = {
  source: string;
  cropTop: number;
  cropLeft?: number;
};

const illustrationSize = { width: 840, height: 1080 };
const sourceHeight = 1825;

const ExistingIllustration: React.FC<IllustrationProps> = ({
  source,
  cropTop,
  cropLeft = 12,
}) => {
  const frame = useCurrentFrame();
  const progress = (Math.sin((frame / 90) * Math.PI * 2) + 1) / 2;
  const translateY = interpolate(progress, [0, 1], [-8, 8], {
    easing: Easing.inOut(Easing.ease),
  });
  const scale = interpolate(progress, [0, 1], [1.012, 1.026]);

  return (
    <AbsoluteFill style={{ overflow: "hidden", backgroundColor: "#ffffff" }}>
      <Img
        src={staticFile(source)}
        style={{
          height: sourceHeight,
          left: -cropLeft,
          position: "absolute",
          top: -cropTop,
          translate: `0 ${translateY}px`,
          scale,
          transformOrigin: "center",
          width: 864,
        }}
      />
    </AbsoluteFill>
  );
};

export const MyComposition = () => {
  return (
    <>
      <Composition
        id="OnboardingWelcomeIllustration"
        component={ExistingIllustration}
        defaultProps={{ source: "onboarding_welcome.png", cropTop: 120 }}
        durationInFrames={90}
        fps={30}
        {...illustrationSize}
      />
      <Composition
        id="OnboardingConsultationIllustration"
        component={ExistingIllustration}
        defaultProps={{ source: "onboarding_consultation.png", cropTop: 155, cropLeft: 12 }}
        durationInFrames={90}
        fps={30}
        {...illustrationSize}
      />
      <Composition
        id="OnboardingRecordsIllustration"
        component={ExistingIllustration}
        defaultProps={{ source: "onboarding_records.png", cropTop: 135, cropLeft: 12 }}
        durationInFrames={90}
        fps={30}
        {...illustrationSize}
      />
    </>
  );
};
