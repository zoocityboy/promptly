import { defineCollection, z } from 'astro:content';
import { docsLoader } from '@astrojs/starlight/loaders';
import { docsSchema } from '@astrojs/starlight/schema';

export const collections = {
	docs: defineCollection({
		loader: docsLoader(),
		schema: docsSchema({
			extend: ({image}) => z.object({
				// // Make a built-in field required instead of optional.
				description: z.string(),
				// // Add a new field to the schema.
				category: z.enum(['theme','code']).optional(),

				cover: image().optional(),
			}),
		})
	}),
};
