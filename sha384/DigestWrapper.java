import org.bouncycastle.crypto.digests.SHA384Digest;
import java.util.Arrays;

public class DigestWrapper {
  public static void testSha(SHA384Digest digest, byte[] input, byte[] output) {
    digest.update(input, 0, input.length);
    digest.doFinal(output, 0);
  }
}
