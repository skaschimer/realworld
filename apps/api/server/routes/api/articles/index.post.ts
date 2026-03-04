import articleMapper from "~/utils/article.mapper";
import HttpException from "~/models/http-exception.model";
import slugify from 'slugify';
import {definePrivateEventHandler} from "~/auth-event-handler";
import {createArticleSchema} from '~/schemas/article.schema';
import {validateBody} from '~/utils/validate';

export default definePrivateEventHandler(async (event, {auth}) => {
    const {article} = validateBody(createArticleSchema, await readBody(event));

    const {title, description, body, tagList} = article;

    const slug = `${slugify(title)}-${auth.id}`;

    const existingTitle = await usePrisma().article.findUnique({
        where: {
            slug,
        },
        select: {
            slug: true,
        },
    });

    if (existingTitle) {
        throw new HttpException(409, { errors: { title: ['has already been taken'] } });
    }

    const {
        authorId,
        id: articleId,
        ...createdArticle
    } = await usePrisma().article.create({
        data: {
            title,
            description,
            body,
            slug,
            tagList: {
                connectOrCreate: tagList.map((tag: string) => ({
                    create: { name: tag },
                    where: { name: tag },
                })),
            },
            author: {
                connect: {
                    id: auth.id,
                },
            },
        },
        include: {
            tagList: {
                select: {
                    name: true,
                },
            },
            author: {
                select: {
                    username: true,
                    bio: true,
                    image: true,
                    followedBy: true,
                },
            },
            favoritedBy: true,
            _count: {
                select: {
                    favoritedBy: true,
                },
            },
        },
    });

    setResponseStatus(event, 201);
    return {article: articleMapper(createdArticle, auth.id)};
});
