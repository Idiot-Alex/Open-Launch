import type { NextConfig } from "next"

import createMDX from "@next/mdx"
import remarkGfm from "remark-gfm"

const nextConfig: NextConfig = {
  /* config options here */

  // Configuration pour MDX
  pageExtensions: ["js", "jsx", "md", "mdx", "ts", "tsx"],
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "*",
      },
    ],
  },
}

const withMDX = createMDX({
  options: {
    remarkPlugins: [remarkGfm],
  },
})

// Combine MDX and Next.js config
export default withMDX(nextConfig)
