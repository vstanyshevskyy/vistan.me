import { articles, projects, talks } from "./content";
import {
  certificates,
  education,
  languages,
  skills,
  technologies,
} from "./credentials";
import { experience, volunteering } from "./experience";
import { profile } from "./profile";

export const site = {
  ...profile,
  experience,
  articles,
  projects,
  talks,
  volunteering,
  certificates,
  skills,
  technologies,
  education,
  languages,
};
