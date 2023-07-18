import { PartialType } from '@nestjs/mapped-types';
import { CreateErc20Dto } from './create-erc20.dto';

export class UpdateErc20Dto extends PartialType(CreateErc20Dto) {}
